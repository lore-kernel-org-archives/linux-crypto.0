From: Binoy Jayan <binoy.jayan@linaro.org>
Subject: Re: [RFC PATCH v4] IV Generation algorithms for dm-crypt
Date: Wed, 1 Mar 2017 23:34:49 +0530
Message-ID: <CAHv-k_93zbve7nOBWrMERt_9sD9VfaF18Y9+P+9Tqd_rXE96gA@mail.gmail.com>
References: <1486463731-6224-1-git-send-email-binoy.jayan@linaro.org>
	<CAOtvUMcN8s886978vE6T=AE79KkZsLBnXsmhewnb5PB0UyAG3A@mail.gmail.com>
	<CAHv-k_8rgArzV2uQ64h1ZTNRpssX1jMf=RwuPoBmsjQ0FhCsWA@mail.gmail.com>
	<68f70534-a309-46ba-a84d-8acc1e6620e5@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6998054475809986700=="
Cc: Rajendra <rnayak@codeaurora.org>, Herbert Xu <herbert@gondor.apana.org.au>,
        Oded <oded.golombek@arm.com>, Mike Snitzer <snitzer@redhat.com>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Ondrej Mosnacek <omosnace@redhat.com>, linux-raid@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>, dm-devel@redhat.com,
        Mark Brown <broonie@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-crypto@vger.kernel.org, Shaohua Li <shli@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alasdair Kergon <agk@redhat.com>, Ofir <Ofir.Drang@arm.com>
To: Milan Broz <gmazyland@gmail.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <68f70534-a309-46ba-a84d-8acc1e6620e5@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
List-Id: linux-crypto.vger.kernel.org

--===============6998054475809986700==
Content-Type: multipart/alternative; boundary=001a11457aae0e08070549af263a

--001a11457aae0e08070549af263a
Content-Type: text/plain; charset=UTF-8

Hi Milan,

On 1 March 2017 at 02:35, Milan Broz <gmazyland@gmail.com> wrote:

> On 02/22/2017 07:12 AM, Binoy Jayan wrote:
> >
> > I was wondering if this is near to be ready for submission (apart from
> > the testmgr.c
> > changes) or I need to make some changes to make it similar to the IPSec
> offload?
>
> I just tried this and except it registers the IV for every new device
> again, it works...
> (After a while you have many duplicate entries in /proc/crypto.)


It is because the the crypto lookup api sees that the crypto algorithm is in
a LARVAL state and registers a new instance every time by invoking the
".create" callback. I guess it should be solved by adding test data to
testmgr.

Do you have some real performance numbers that proves that such a patch is
> adequate?
>

While waiting to do some implementation of the hw crypto drivers to work
with
dm-crypt, I'll also generate some numbers to compare the performance with
the
original dm-crypt code with the new one with a software implementation in
place.


> I would really like to see the performance issue fixed but I am really not
> sure
> this approach works for everyone. It would be better to avoid repeating
> this exercise later.
> IIRC Ondra's "bulk" mode, despite rejected, shows that there is a potential
> to speedup things even for crypt drivers that do not support own IV
> generators.
>

I think it should work for everyone (even for ciphers not supporting IVs)
if the null IV
mode is used. It should be upto the IV generation template to choose to
generate IV
or just call the underlying (base) template/cipher.

Regards,
Binoy

--001a11457aae0e08070549af263a
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi Milan,<br><div class=3D"gmail_extra"><br><div class=3D"=
gmail_quote">On 1 March 2017 at 02:35, Milan Broz <span dir=3D"ltr">&lt;<a =
href=3D"mailto:gmazyland@gmail.com" target=3D"_blank">gmazyland@gmail.com</=
a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:0=
px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex"><=
span class=3D"gmail-">On 02/22/2017 07:12 AM, Binoy Jayan wrote:<br>
&gt;<br>
&gt; I was wondering if this is near to be ready for submission (apart from=
<br>
&gt; the testmgr.c<br>
&gt; changes) or I need to make some changes to make it similar to the IPSe=
c offload?<br>
<br>
</span>I just tried this and except it registers the IV for every new devic=
e again, it works...<br>
(After a while you have many duplicate entries in /proc/crypto.)</blockquot=
e><div><br></div><div>It is because the the crypto lookup api sees that the=
 crypto algorithm is in</div><div>a LARVAL state and registers a new instan=
ce every time by invoking the</div><div>&quot;.create&quot; callback. I gue=
ss it should be solved by adding test data to testmgr.</div><div><br></div>=
<blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-=
left:1px solid rgb(204,204,204);padding-left:1ex">Do you have some real per=
formance numbers that proves that such a patch is adequate?<br></blockquote=
><div><br></div><div>While waiting to do some implementation of the hw cryp=
to drivers to work with</div><div>dm-crypt, I&#39;ll also generate some num=
bers to compare the performance with the</div><div>original dm-crypt code w=
ith the new one with a software implementation in place.</div><div>=C2=A0</=
div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;bor=
der-left:1px solid rgb(204,204,204);padding-left:1ex">
I would really like to see the performance issue fixed but I am really not =
sure<br>
this approach works for everyone. It would be better to avoid repeating thi=
s exercise later.<br>
IIRC Ondra&#39;s &quot;bulk&quot; mode, despite rejected, shows that there =
is a potential<br>
to speedup things even for crypt drivers that do not support own IV generat=
ors.<br></blockquote><div><br></div><div>I think it should work for everyon=
e (even for ciphers not supporting IVs) if the null IV</div><div>mode is us=
ed. It should be upto the IV generation template to choose to generate IV</=
div><div>or just call the underlying (base) template/cipher.</div><div>=C2=
=A0</div><div>Regards,</div><div>Binoy</div><div><br></div><div><br></div><=
/div></div></div>

--001a11457aae0e08070549af263a--


--===============6998054475809986700==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============6998054475809986700==--
