From: Harsh Jain <Harsh-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: Re: DMA error when sg->offset value is greater than PAGE_SIZE in
	Intel IOMMU
Date: Thu, 28 Sep 2017 16:41:56 +0530
Message-ID: <d9cb1527-9139-38a4-6987-54cdcda9ebe6@chelsio.com>
References: <6d2af675-7b97-6eaf-4daa-d7bf80a05923@chelsio.com>
	<437a9bd8-d4d6-22ca-1a64-1a3e73f1101a@arm.com>
	<MWHPR12MB1600694D099E1CFAD6849A68C87B0@MWHPR12MB1600.namprd12.prod.outlook.com>
	<CAPcyv4jtYMZJ6V5VoXkGrcZ+ykWvYp1=qXrqJkjknk8Q_BVwgA@mail.gmail.com>
	<MWHPR12MB160060436AC70CB5BE8C0C6EC8780@MWHPR12MB1600.namprd12.prod.outlook.com>
	<20170927181802.3dcd7efb@m750.lan> <20170927144847.GA95654@otc-nc-03>
	<MWHPR12MB16005D59D7A33F3D5BE43395C8780@MWHPR12MB1600.namprd12.prod.outlook.com>
	<20170927190745.GA96373@otc-nc-03>
	<MWHPR12MB16007E5363E79173C52BFA19C8780@MWHPR12MB1600.namprd12.prod.outlook.com>
	<20170928103312.GB8118@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7085232034161213081=="
Cc: "nd-5wv7dgnIgG8@public.gmane.org" <nd-5wv7dgnIgG8@public.gmane.org>, "dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org" <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
	"linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>,
	"linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
	Michael Werner <werner-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
To: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>, Casey Leedom <leedom-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20170928103312.GB8118-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
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

This is a multi-part message in MIME format.
--===============7085232034161213081==
Content-Type: multipart/alternative;
 boundary="------------3B42DDA35314BE1D88DE770F"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------3B42DDA35314BE1D88DE770F
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit



On 28-09-2017 16:03, Herbert Xu wrote:
> On Wed, Sep 27, 2017 at 10:13:04PM +0000, Casey Leedom wrote:
>> | From: Raj, Ashok <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> | Sent: Wednesday, September 27, 2017 12:07 PM
>> |
>> | looking at the debug output i got from Harsh it still looks like a bug in
>> | the code.
>> |
>> | [  538.284589] __domain_mapping nr_pages 0x1
>> | [ 538.284600] __domain_mapping sg_res 0x1 sg->dma_address 0xf291000e dma len
>> | 0x38 pteval 0x3cbce3003 phys_pfn 0x3cbce3
>> | [ 538.284604] chelsio driver - offset 4110 len 56 dma addr f291000e dma len
>> | 56
>> | [  538.284667] DMAR: DRHD: handling fault status reg 2
>> | [ 538.290017] DMAR: [DMA Write] Request device [02:00.4] fault addr f2910000
>> | [fault reason 05] PTE Write access is not set
>> |
>> | somehow when crypto_authenc_encrypt() -> scatterwalk_ffwd()-> sg_set_page()
>> |
>> | ->sg_set_page(dst, sg_page(src), src->length - len, src->offset + len);
>> |
>> | src->offset + len gets set as sg->offset in sg_set_page(). Either the
>> | assumption that there should be room is incorrect, or some higher order
>> | crypto
>> | code that ends up setting the offset did the wrong calculation.
>> |
>> | if src->offset is already towards the end of the page, then offset+len will
>> | go beyond the end of page.
>>
>>   Hhmmm, it seems like we need Herbert to comment on this.
>>
>>   Herbert, is there any specific debugging information that you'd like to
>> see here?
> OK I was mistaken.  While SG lists can contain entries that are
> larger than PAGE_SIZE, there is no reason why scatterwalk_ffwd
> should gratuitously insert a page_offset that is greater than
> PAGE_SIZE.
>
> Harsh, can you please submit your original patch with a sign-off?
Herbert, There are some points which bothers me.
1) That patch solve panic later on after reporting the issue,  I can see DMA_write error traces with iperf traffic.
2) It seems we(crypto) are not the only one who adjust offsets like this. refer "__skb_to_sgvec <http://elixir.free-electrons.com/linux/latest/ident/__skb_to_sgvec>"  . There can be many more.

sg_set_page <http://elixir.free-electrons.com/linux/latest/ident/sg_set_page>(&sg[elt], skb_frag_page <http://elixir.free-electrons.com/linux/latest/ident/skb_frag_page>(frag <http://elixir.free-electrons.com/linux/latest/ident/frag>), copy <http://elixir.free-electrons.com/linux/latest/ident/copy>,
					frag <http://elixir.free-electrons.com/linux/latest/ident/frag>->page_offset <http://elixir.free-electrons.com/linux/latest/ident/page_offset>+offset-start); 3) Yesterday Ashok suggested to run the test with boot parameter Intel_iommu=sp_off. With yhis Even Iperf traffic runs seemlessly.

Don't know what this has changed.

>
> Thanks,


--------------3B42DDA35314BE1D88DE770F
Content-Type: text/html; charset=utf-8
Content-Transfer-Encoding: 8bit

<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
  </head>
  <body text="#000000" bgcolor="#FFFFFF">
    <p><br>
    </p>
    <br>
    <div class="moz-cite-prefix">On 28-09-2017 16:03, Herbert Xu wrote:<br>
    </div>
    <blockquote type="cite"
      cite="mid:20170928103312.GB8118-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org">
      <pre wrap="">On Wed, Sep 27, 2017 at 10:13:04PM +0000, Casey Leedom wrote:
</pre>
      <blockquote type="cite">
        <pre wrap="">| From: Raj, Ashok <a class="moz-txt-link-rfc2396E" href="mailto:ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org">&lt;ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org&gt;</a>
| Sent: Wednesday, September 27, 2017 12:07 PM
|
| looking at the debug output i got from Harsh it still looks like a bug in
| the code.
|
| [  538.284589] __domain_mapping nr_pages 0x1
| [ 538.284600] __domain_mapping sg_res 0x1 sg-&gt;dma_address 0xf291000e dma len
| 0x38 pteval 0x3cbce3003 phys_pfn 0x3cbce3
| [ 538.284604] chelsio driver - offset 4110 len 56 dma addr f291000e dma len
| 56
| [  538.284667] DMAR: DRHD: handling fault status reg 2
| [ 538.290017] DMAR: [DMA Write] Request device [02:00.4] fault addr f2910000
| [fault reason 05] PTE Write access is not set
|
| somehow when crypto_authenc_encrypt() -&gt; scatterwalk_ffwd()-&gt; sg_set_page()
|
| -&gt;sg_set_page(dst, sg_page(src), src-&gt;length - len, src-&gt;offset + len);
|
| src-&gt;offset + len gets set as sg-&gt;offset in sg_set_page(). Either the
| assumption that there should be room is incorrect, or some higher order
| crypto
| code that ends up setting the offset did the wrong calculation.
|
| if src-&gt;offset is already towards the end of the page, then offset+len will
| go beyond the end of page.

  Hhmmm, it seems like we need Herbert to comment on this.

  Herbert, is there any specific debugging information that you'd like to
see here?
</pre>
      </blockquote>
      <pre wrap="">
OK I was mistaken.  While SG lists can contain entries that are
larger than PAGE_SIZE, there is no reason why scatterwalk_ffwd
should gratuitously insert a page_offset that is greater than
PAGE_SIZE.

Harsh, can you please submit your original patch with a sign-off?</pre>
    </blockquote>
    Herbert, There are some points which bothers me.<br>
    1) That patch solve panic later on after reporting the issue,  I can
    see DMA_write error traces with iperf traffic.<br>
    2) It seems we(crypto) are not the only one who adjust offsets like
    this. refer "<span class="nf"><a
href="http://elixir.free-electrons.com/linux/latest/ident/__skb_to_sgvec">__skb_to_sgvec</a></span><span
      class="p"></span>"  . There can be many more.<br>
    <pre><span class="n"><a href="http://elixir.free-electrons.com/linux/latest/ident/sg_set_page">sg_set_page</a></span><span class="p">(</span><span class="o">&amp;</span><span class="n">sg</span><span class="p">[</span><span class="n">elt</span><span class="p">],</span> <span class="n"><a href="http://elixir.free-electrons.com/linux/latest/ident/skb_frag_page">skb_frag_page</a></span><span class="p">(</span><span class="n"><a href="http://elixir.free-electrons.com/linux/latest/ident/frag">frag</a></span><span class="p">),</span> <span class="n"><a href="http://elixir.free-electrons.com/linux/latest/ident/copy">copy</a></span><span class="p">,</span>
					<span class="n"><a href="http://elixir.free-electrons.com/linux/latest/ident/frag">frag</a></span><span class="o">-&gt;</span><span class="n"><a href="http://elixir.free-electrons.com/linux/latest/ident/page_offset">page_offset</a></span><span class="o">+</span><span class="n">offset</span><span class="o">-</span><span class="n">start</span><span class="p">);
3) Yesterday Ashok suggested to run the test with boot parameter </span>Intel_iommu=sp_off. With yhis Even Iperf traffic runs seemlessly.

Don't know what this has changed.<span class="p"></span></pre>
    <blockquote type="cite"
      cite="mid:20170928103312.GB8118-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org">
      <pre wrap="">

Thanks,
</pre>
    </blockquote>
    <br>
  </body>
</html>

--------------3B42DDA35314BE1D88DE770F--

--===============7085232034161213081==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============7085232034161213081==--
