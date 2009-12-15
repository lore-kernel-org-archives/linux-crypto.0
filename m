From: "Suresh Vishnu-B05022" <B05022@freescale.com>
Subject: RE: [PATCH v0] Crypto: Talitos: re-initialize async_tx descriptors
Date: Tue, 15 Dec 2009 16:33:42 +0530
Message-ID: <76952DF81420A349876E087D089DF034562C75@zin33exm21.fsl.freescale.net>
References: <1260797602-7476-1-git-send-email-Vishnu@freescale.com>
	<e9c3a7c20912142329j6603402ah2963d075419efa1c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2599548354204149037=="
Cc: herbert@gondor.apana.org.au, Tabi Timur-B04825 <B04825@freescale.com>,
	linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
	linuxppc-dev@ozlabs.org, linux-crypto@vger.kernel.org,
	Li Yang-R58472 <r58472@freescale.com>
To: "Dan Williams" <dan.j.williams@intel.com>
Return-path: <linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@lists.ozlabs.org>
Content-class: urn:content-classes:message
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
	<mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
	<mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Sender: linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@lists.ozlabs.org
Errors-To: linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@lists.ozlabs.org
List-Id: linux-crypto.vger.kernel.org

This is a multi-part message in MIME format.

--===============2599548354204149037==
Content-class: urn:content-classes:message
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01CA7D76.437CCC34"

This is a multi-part message in MIME format.

------_=_NextPart_001_01CA7D76.437CCC34
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

> On Mon, Dec 14, 2009 at 6:33 AM, Vishnu Suresh <Vishnu@freescale.com> =
wrote:
> > The async_tx descriptors contains dangling pointers.
> > Hence, re-initialize them to NULL before use.
> >
> > Signed-off-by: Vishnu Suresh <Vishnu@freescale.com>
> > ---
> > o. Rebased to linux-next as of 20091214
> >
> >  drivers/crypto/talitos.c |    3 +++
> >  1 files changed, 3 insertions(+), 0 deletions(-)
> >
> > diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
> > index 87f06be..9e261c6 100644
> > --- a/drivers/crypto/talitos.c
> > +++ b/drivers/crypto/talitos.c
> > @@ -952,6 +952,9 @@ static struct dma_async_tx_descriptor * =
talitos_prep_dma_xor(
> >                return NULL;
> >        }
> >        dma_async_tx_descriptor_init(&new->async_tx, =
&xor_chan->common);
> > +       new->async_tx.parent =3D NULL;
> > +       new->async_tx.next =3D NULL;
> > +
> >
> >        desc =3D &new->hwdesc;
> >        /* Set destination: Last pointer pair */

> These two values are owned by the async_tx api, drivers are not
> supposed to touch them.
I have sent this patch and the similar one for fsldma seperately,=20
so that if the changes are needed and can be done in =
dma_async_tx_descriptor_init(),=20
these patches can be ignored. =20
> Both iop_adma and the new ppx4xx driver
> (which use the async_tx channel switching capability) get away without
> touching these fields which makes me suspect there is a
> misunderstanding/bug somewhere else in the talitos implementation.

This bug does not occur on all the platforms. The occurrance is random.=20
This occurs when a channel switch between two different devices are =
present.=20
This same initialization is required in case of fsldma as well.=20
In case of fsldma/talitosXOR, there are two DMA channels (on same =
device) and single XOR channel (on another device).=20

When used without fsldma, this driver works fine.
Does iop_adma and ppx4xx work in similar enviroment?

> > Also that dma_async_tx_descriptor_init() is unexpected in the hot
> > path, it's only needed at initial descriptor allocation.  End result =
I
> > think this driver needs some more time to brew.



> --
> Dan




------_=_NextPart_001_01CA7D76.437CCC34
Content-Type: text/html;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<HTML dir=3Dltr><HEAD><TITLE>Re: [PATCH v0] Crypto: Talitos: =
re-initialize async_tx descriptors</TITLE>=0A=
<META http-equiv=3DContent-Type content=3D"text/html; charset=3Dunicode">=0A=
<META content=3D"MSHTML 6.00.2900.3627" name=3DGENERATOR></HEAD>=0A=
<BODY>=0A=
<DIV id=3DidOWAReplyText95776 dir=3Dltr>=0A=
<DIV dir=3Dltr><FONT size=3D2>&gt; On Mon, Dec 14, 2009 at 6:33 AM, =
Vishnu Suresh &lt;Vishnu@freescale.com&gt; wrote:<BR>&gt; &gt; The =
async_tx descriptors contains dangling pointers.<BR>&gt; &gt; Hence, =
re-initialize them to NULL before use.<BR>&gt; &gt;<BR>&gt; &gt; =
Signed-off-by: Vishnu Suresh &lt;Vishnu@freescale.com&gt;<BR>&gt; &gt; =
---<BR>&gt; &gt; o. Rebased to linux-next as of 20091214<BR>&gt; =
&gt;<BR>&gt; &gt; &nbsp;drivers/crypto/talitos.c | &nbsp; &nbsp;3 =
+++<BR>&gt; &gt; &nbsp;1 files changed, 3 insertions(+), 0 =
deletions(-)<BR>&gt; &gt;<BR>&gt; &gt; diff --git =
a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c<BR>&gt; &gt; index =
87f06be..9e261c6 100644<BR>&gt; &gt; --- =
a/drivers/crypto/talitos.c<BR>&gt; &gt; +++ =
b/drivers/crypto/talitos.c<BR>&gt; &gt; @@ -952,6 +952,9 @@ static =
struct dma_async_tx_descriptor * talitos_prep_dma_xor(<BR>&gt; &gt; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;return =
NULL;<BR>&gt; &gt; &nbsp; &nbsp; &nbsp; &nbsp;}<BR>&gt; &gt; &nbsp; =
&nbsp; &nbsp; &nbsp;dma_async_tx_descriptor_init(&amp;new-&gt;async_tx, =
&amp;xor_chan-&gt;common);<BR>&gt; &gt; + &nbsp; &nbsp; &nbsp; =
new-&gt;async_tx.parent =3D NULL;<BR>&gt; &gt; + &nbsp; &nbsp; &nbsp; =
new-&gt;async_tx.next =3D NULL;<BR>&gt; &gt; +<BR>&gt; &gt;<BR>&gt; &gt; =
&nbsp; &nbsp; &nbsp; &nbsp;desc =3D &amp;new-&gt;hwdesc;<BR>&gt; &gt; =
&nbsp; &nbsp; &nbsp; &nbsp;/* Set destination: Last pointer pair =
*/<BR><BR>&gt; These two values are owned by the async_tx api, drivers =
are not<BR>&gt; supposed to touch them.</FONT></DIV>=0A=
<DIV dir=3Dltr><FONT size=3D2>I have sent this patch and =
the&nbsp;similar one for fsldma seperately, <BR>so that if the =
changes&nbsp;are needed and can be done in =
dma_async_tx_descriptor_init(), <BR>these patches can be ignored.&nbsp; =
</FONT></DIV>=0A=
<DIV dir=3Dltr><FONT size=3D2>&gt; Both iop_adma and the new ppx4xx =
driver<BR>&gt; (which use the async_tx channel switching capability) get =
away without<BR>&gt; touching these fields which makes me suspect there =
is a<BR>&gt; misunderstanding/bug somewhere else in the talitos =
implementation.</FONT></DIV></DIV>=0A=
<DIV>=0A=
<P><FONT size=3D2>This bug&nbsp;does&nbsp;not&nbsp;occur on all the =
platforms. The occurrance&nbsp;is random. <BR>This occurs when a channel =
switch between two different devices are present. <BR></FONT><FONT =
size=3D2>This same initialization is required in case of fsldma as =
well.&nbsp;<BR>In case of fsldma/talitosXOR, there are two&nbsp;DMA =
channels (on same device) and single XOR channel (on another device). =
</FONT></P>=0A=
<P><FONT size=3D2>When used without fsldma, this driver works =
fine.<BR>Does iop_adma and ppx4xx work in similar enviroment?</FONT></P>=0A=
<P><FONT size=3D2>&gt; &gt; Also that dma_async_tx_descriptor_init() is =
unexpected in the hot<BR>&gt; &gt; path, it's only needed at initial =
descriptor allocation.&nbsp; End result I<BR>&gt; &gt; think this driver =
needs some more time to brew.</FONT></P>=0A=
<P><FONT size=3D2><BR><BR>&gt; --<BR>&gt; =
Dan<BR><BR></P></FONT></DIV></BODY></HTML>
------_=_NextPart_001_01CA7D76.437CCC34--

--===============2599548354204149037==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Linuxppc-dev mailing list
Linuxppc-dev@lists.ozlabs.org
https://lists.ozlabs.org/listinfo/linuxppc-dev
--===============2599548354204149037==--
