From: Casey Leedom <leedom-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: Re: DMA error when sg->offset value is greater than PAGE_SIZE in
	Intel IOMMU
Date: Tue, 26 Sep 2017 16:06:30 +0000
Message-ID: <MWHPR12MB1600694D099E1CFAD6849A68C87B0@MWHPR12MB1600.namprd12.prod.outlook.com>
References: <20170920080151.GA3348@gondor.apana.org.au>
	<26992a1e-edb3-ed78-ce8e-31e0739d75f4@arm.com>
	<MWHPR12MB160092A868C613FF64CA9EE9C87A0@MWHPR12MB1600.namprd12.prod.outlook.com>
	<20170925155430.GB131920@otc-nc-03>
	<MWHPR12MB16004E2A92CC3FFEC6313DDBC87A0@MWHPR12MB1600.namprd12.prod.outlook.com>
	<afa02763-4556-0e14-7d1b-1c044cdc1ff7@chelsio.com>
	<6d2af675-7b97-6eaf-4daa-d7bf80a05923@chelsio.com>,
	<437a9bd8-d4d6-22ca-1a64-1a3e73f1101a@arm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2121506724965465080=="
Cc: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
	"linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>,
	"linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
	Michael Werner <werner-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>,
	"dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org" <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
	David Woodhouse <David.Woodhouse-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
To: Robin Murphy <robin.murphy-5wv7dgnIgG8@public.gmane.org>, "Harsh  Jain" <Harsh-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>,
	"Raj, Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <437a9bd8-d4d6-22ca-1a64-1a3e73f1101a-5wv7dgnIgG8@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

--===============2121506724965465080==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_MWHPR12MB1600694D099E1CFAD6849A68C87B0MWHPR12MB1600namp_"

--_000_MWHPR12MB1600694D099E1CFAD6849A68C87B0MWHPR12MB1600namp_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

| From: Robin Murphy <robin.murphy-5wv7dgnIgG8@public.gmane.org>
| Sent: Tuesday, September 26, 2017 7:22 AM
|
| On 26/09/17 13:21, Harsh Jain wrote:
| > Find attached new set of log. After repeated tries it panics.
|
| Thanks, that makes things a bit clearer - looks like fixing the physical
| address/pteval calculation to not be off by a page in one direction wasn'=
t
| helping much because the returned DMA address is actually also off by a
| page in the other direction, and thus overflowing past the allocated IOVA
| into whoever else's mapping happened to be there; complete carnage ensues=
.
|
| After another look through the intel_map_sg() path, here's my second (sti=
ll
| completely untested) guess at a possible fix.
|
| Robin.
|
| ----->8-----
| diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
| index 6784a05dd6b2..d7f7def81613 100644
| --- a/drivers/iommu/intel-iommu.c
| +++ b/drivers/iommu/intel-iommu.c
| @@ -2254,10 +2254,12 @@ static int __domain_mapping(struct dmar_domain *d=
omain, unsigned long iov_pfn,
|                  uint64_t tmp;
|
|                  if (!sg_res) {
| +                       size_t off =3D sg->offset & ~PAGE_MASK;
| +
|                          sg_res =3D aligned_nrpages(sg->offset, sg->lengt=
h);
| -                       sg->dma_address =3D ((dma_addr_t)iov_pfn << VTD_P=
AGE_SHIFT) + sg->offset;
| +                       sg->dma_address =3D ((dma_addr_t)iov_pfn << VTD_P=
AGE_SHIFT) + off;
|                          sg->dma_length =3D sg->length;
| -                       pteval =3D page_to_phys(sg_page(sg)) | prot;
| +                       pteval =3D (page_to_phys(sg_page(sg)) + sg->offse=
t - off) | prot;
|                          phys_pfn =3D pteval >> VTD_PAGE_SHIFT;
|                  }

  Thanks Robin.  And thanks Harsh for sending the detailed trace logs.  I'l=
l
see if I can get this tested today.  Harsh is probably headed towards bed,
but there may be sufficiently good instructions in our internal bug system
to reproduce the issue.

  Regardless, it seems that you agree that there's an issue with the Intel
I/O MMU support code with regard to the legal values which a (struct
scatterlist) can take on?  I still can't find any documentation for this
and, personally, I'm a bit baffled by a Page-oriented Scatter/Gather List
representation where [Offset, Offset+Length) can reside outside the Page.

  If this is a bug in the Intel I/O MMU support code, then we can caveat
to our customers pending an official fix for the issue.

Casey


--_000_MWHPR12MB1600694D099E1CFAD6849A68C87B0MWHPR12MB1600namp_
Content-Type: text/html; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Diso-8859-=
1">
<style type=3D"text/css" style=3D"display:none;"><!-- P {margin-top:0;margi=
n-bottom:0;} --></style>
</head>
<body dir=3D"ltr">
<div id=3D"divtagdefaultwrapper" style=3D"font-size:12pt;color:#000000;font=
-family:Calibri,Helvetica,sans-serif;" dir=3D"ltr">
<div>| From: Robin Murphy &lt;robin.murphy-5wv7dgnIgG8@public.gmane.org&gt;<br>
| Sent: Tuesday, September 26, 2017 7:22 AM<br>
|<br>
| On 26/09/17 13:21, Harsh Jain wrote:<br>
| &gt; Find attached new set of log. After repeated tries it panics.<br>
|<br>
| Thanks, that makes things a bit clearer - looks like fixing the physical<=
br>
| address/pteval calculation to not be off by a page in one direction wasn'=
t<br>
| helping much because the returned DMA address is actually also off by a<b=
r>
| page in the other direction, and thus overflowing past the allocated IOVA=
<br>
| into whoever else's mapping happened to be there; complete carnage ensues=
.<br>
|<br>
| After another look through the intel_map_sg() path, here's my second (sti=
ll<br>
| completely untested) guess at a possible fix.<br>
|<br>
| Robin.<br>
|<br>
| -----&gt;8-----<br>
| diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c<br=
>
| index 6784a05dd6b2..d7f7def81613 100644<br>
| --- a/drivers/iommu/intel-iommu.c<br>
| &#43;&#43;&#43; b/drivers/iommu/intel-iommu.c<br>
| @@ -2254,10 &#43;2254,12 @@ static int __domain_mapping(struct dmar_domai=
n *domain, unsigned long iov_pfn,<br>
|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp; uint64_t tmp;<br>
|<br>
|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp; if (!sg_res) {<br>
| &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; size_t off=
 =3D sg-&gt;offset &amp; ~PAGE_MASK;<br>
| &#43;<br>
|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
; sg_res =3D aligned_nrpages(sg-&gt;offset, sg-&gt;length);<br>
| -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; sg-&gt;dma_add=
ress =3D ((dma_addr_t)iov_pfn &lt;&lt; VTD_PAGE_SHIFT) &#43; sg-&gt;offset;=
<br>
| &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; sg-&gt;dma=
_address =3D ((dma_addr_t)iov_pfn &lt;&lt; VTD_PAGE_SHIFT) &#43; off;<br>
|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
; sg-&gt;dma_length =3D sg-&gt;length;<br>
| -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; pteval =3D pag=
e_to_phys(sg_page(sg)) | prot;<br>
| &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; pteval =3D=
 (page_to_phys(sg_page(sg)) &#43; sg-&gt;offset - off) | prot;<br>
|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
; phys_pfn =3D pteval &gt;&gt; VTD_PAGE_SHIFT;<br>
|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp; }<br>
<br>
&nbsp; Thanks Robin.&nbsp; And thanks Harsh for sending the detailed trace =
logs.&nbsp; I'll<br>
see if I can get this tested today.&nbsp; Harsh is probably headed towards =
bed,<br>
but there may be sufficiently good instructions in our internal bug system<=
br>
to reproduce the issue.<br>
<br>
&nbsp; Regardless, it seems that you agree that there's an issue with the I=
ntel<br>
I/O MMU support code with regard to the legal values which a (struct<br>
scatterlist) can take on?&nbsp; I still can't find any documentation for th=
is<br>
and, personally, I'm a bit baffled by a Page-oriented Scatter/Gather List<b=
r>
representation where [Offset, Offset&#43;Length) can reside outside the Pag=
e.<br>
<br>
&nbsp; If this is a bug in the Intel I/O MMU support code, then we can cave=
at<br>
to our customers pending an official fix for the issue.<br>
<br>
Casey<br>
</div>
<br>
</div>
</body>
</html>

--_000_MWHPR12MB1600694D099E1CFAD6849A68C87B0MWHPR12MB1600namp_--

--===============2121506724965465080==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2121506724965465080==--
