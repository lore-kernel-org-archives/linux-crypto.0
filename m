From: Martin Hicks <mort@bork.org>
Subject: Re: [PATCH 0/5] crypto: talitos: Add crypto async queue handling
Date: Fri, 20 Feb 2015 13:23:28 -0500
Message-ID: <CAJUS3XmnuUhgezxhBKeu2QLk-QqGVf3ZuwSycs_w=J3KC3BATg@mail.gmail.com>
References: <1424449276-5288-1-git-send-email-mort@bork.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4383561884470245796=="
Cc: Martin Hicks <mort@bork.org>, linuxppc-dev@lists.ozlabs.org,
 linux-crypto@vger.kernel.org
To: Kim Phillips <kim.phillips@freescale.com>,
 Scott Wood <scottwood@freescale.com>,
 Kumar Gala <galak@kernel.crashing.org>
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <1424449276-5288-1-git-send-email-mort@bork.org>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
List-Id: linux-crypto.vger.kernel.org

--===============4383561884470245796==
Content-Type: multipart/alternative; boundary=047d7bdca5b629ab7b050f89263d

--047d7bdca5b629ab7b050f89263d
Content-Type: text/plain; charset=UTF-8

I've just noticed that performance is pretty terrible with maxcpus=1, so
I'll investigate that.
mh

On Fri, Feb 20, 2015 at 11:21 AM, Martin Hicks <mort@bork.org> wrote:

> I was testing dm-crypt performance with a Freescale P1022 board with
> a recent kernel and was getting IO errors while doing testing with LUKS.
> Investigation showed that all hardware FIFO slots were filling and
> the driver was returning EAGAIN to the block layer, which is not an
> expected response for an async crypto implementation.
>
> The following patch series adds a few small fixes, and reworks the
> submission path to use the crypto_queue mechanism to handle the
> request backlog.
>
>
> Martin Hicks (5):
>   crypto: talitos: Simplify per-channel initialization
>   crypto: talitos: Remove MD5_BLOCK_SIZE
>   crypto: talitos: Fix off-by-one and use all hardware slots
>   crypto: talitos: Reorganize request submission data structures
>   crypto: talitos: Add software backlog queue handling
>
>  drivers/crypto/talitos.c |  189
> ++++++++++++++++++++++++----------------------
>  drivers/crypto/talitos.h |   44 +++++++++--
>  2 files changed, 137 insertions(+), 96 deletions(-)
>
> --
> 1.7.10.4
>
>


-- 
Martin Hicks P.Eng.      |         mort@bork.org
Bork Consulting Inc.     |   +1 (613) 266-2296

--047d7bdca5b629ab7b050f89263d
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_extra"><br></div><div class=3D"gmail_e=
xtra">I&#39;ve just noticed that performance is pretty terrible with maxcpu=
s=3D1, so I&#39;ll investigate that.</div><div class=3D"gmail_extra">mh</di=
v><div class=3D"gmail_extra"><br><div class=3D"gmail_quote">On Fri, Feb 20,=
 2015 at 11:21 AM, Martin Hicks <span dir=3D"ltr">&lt;<a href=3D"mailto:mor=
t@bork.org" target=3D"_blank">mort@bork.org</a>&gt;</span> wrote:<br><block=
quote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc=
 solid;padding-left:1ex">I was testing dm-crypt performance with a Freescal=
e P1022 board with<br>
a recent kernel and was getting IO errors while doing testing with LUKS.<br=
>
Investigation showed that all hardware FIFO slots were filling and<br>
the driver was returning EAGAIN to the block layer, which is not an<br>
expected response for an async crypto implementation.<br>
<br>
The following patch series adds a few small fixes, and reworks the<br>
submission path to use the crypto_queue mechanism to handle the<br>
request backlog.<br>
<br>
<br>
Martin Hicks (5):<br>
=C2=A0 crypto: talitos: Simplify per-channel initialization<br>
=C2=A0 crypto: talitos: Remove MD5_BLOCK_SIZE<br>
=C2=A0 crypto: talitos: Fix off-by-one and use all hardware slots<br>
=C2=A0 crypto: talitos: Reorganize request submission data structures<br>
=C2=A0 crypto: talitos: Add software backlog queue handling<br>
<br>
=C2=A0drivers/crypto/talitos.c |=C2=A0 189 ++++++++++++++++++++++++--------=
--------------<br>
=C2=A0drivers/crypto/talitos.h |=C2=A0 =C2=A044 +++++++++--<br>
=C2=A02 files changed, 137 insertions(+), 96 deletions(-)<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
--<br>
1.7.10.4<br>
<br>
</font></span></blockquote></div><br><br clear=3D"all"><div><br></div>-- <b=
r><div class=3D"gmail_signature"><div dir=3D"ltr">Martin Hicks P.Eng. =C2=
=A0=C2=A0 =C2=A0 | =C2=A0 =C2=A0 =C2=A0 =C2=A0 <a href=3D"mailto:mort@bork.=
org" target=3D"_blank">mort@bork.org</a><br>Bork Consulting Inc. =C2=A0 =C2=
=A0 | =C2=A0 +1 (613) 266-2296<div></div><div></div><div></div></div></div>
</div></div>

--047d7bdca5b629ab7b050f89263d--

--===============4383561884470245796==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: base64
Content-Disposition: inline

X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KTGludXhwcGMt
ZGV2IG1haWxpbmcgbGlzdApMaW51eHBwYy1kZXZAbGlzdHMub3psYWJzLm9yZwpodHRwczovL2xp
c3RzLm96bGFicy5vcmcvbGlzdGluZm8vbGludXhwcGMtZGV2

--===============4383561884470245796==--
