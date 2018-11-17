Return-Path: <SRS0=r3Tc=N4=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-oi1-f196.google.com ([209.85.167.196]:35662 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725854AbeKQUgH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 17 Nov 2018 15:36:07 -0500
MIME-Version: 1.0
References: <20181023144654.12906-1-andrew.shadura@collabora.co.uk>
 <d848f97e-a9fc-1562-1963-3b608162106d@collabora.co.uk> <nycvar.YFH.7.76.1811121217030.27368@cbobk.fhfr.pm>
 <96148aff-eac8-7e25-dd74-b194b7bae025@collabora.co.uk> <f68e61ad-4983-fc73-d91c-1d4f293a71cc@collabora.co.uk>
In-Reply-To: <f68e61ad-4983-fc73-d91c-1d4f293a71cc@collabora.co.uk>
From: Nick Kossifidis <mickflemm@gmail.com>
Date: Sat, 17 Nov 2018 12:19:42 +0200
Message-ID: <CAFtRNNz=-Kgj+MEio5pDiGiTh-exrkSSY8Jg34eHz4p5esTu2A@mail.gmail.com>
Subject: Re: [PATCH] HID: add driver for U2F Zero built-in LED and RNG
To: andrew.shadura@collabora.co.uk
Cc: jikos@kernel.org, linux-input@vger.kernel.org,
        linux-usb@vger.kernel.org, kernel@collabora.com,
        anarsoul@gmail.com, linux-crypto@vger.kernel.org, conorpp@vt.edu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

=CE=A3=CF=84=CE=B9=CF=82 =CE=A4=CE=B5=CF=84, 14 =CE=9D=CE=BF=CE=B5 2018 =CF=
=83=CF=84=CE=B9=CF=82 9:08 =CE=BC.=CE=BC., =CE=BF/=CE=B7 Andrej Shadura
<andrew.shadura@collabora.co.uk> =CE=AD=CE=B3=CF=81=CE=B1=CF=88=CE=B5:
>
> On 14/11/2018 10:32, Andrej Shadura wrote:
> > On 12/11/2018 03:17, Jiri Kosina wrote:
> >> On Thu, 1 Nov 2018, Andrej Shadura wrote:
> >>
> >>> Hi everyone,
> >>>
> >>> I=E2=80=99ve got a comment from Nick Kossifidis that I probably shoul=
dn=E2=80=99t set
> >>> RNG=E2=80=99s quality to 1024. Adding linux-crypto@ to the loop.
> >>
> >> So, what was this about? Is there any resolution to it? :)
> >
> > So far, not really. I talked to Keith Packard regarding a similar
> > setting in his ChaosKey driver, and I understand his opinion is that it
> > is appropriate there since he=E2=80=99s convinced about the quality of =
the
> > hardware he designed. I=E2=80=99m not sure what exactly I should set it=
 to here.
>
> Just talked to Theodore Ts'o about this, it seems that it doesn=E2=80=99t=
 really
> matter that much what to set it to, since this subsystem apparently will
> be reworked soon, and setting it to a fair value of 0 will apparently
> make it not feed the entropy pool at all, and with a non-zero value only
> one device with the highest value will be used. I=E2=80=99m tempted to re=
submit
> the patch with 0 as the default (as Nick suggested) so that pro users
> can toggle it later from the userspace, but it doesn=E2=80=99t have the
> opportunity to potentially poison the entropy pool if it=E2=80=99s compro=
mised.
>

I think that's better, good to know the subsystem is being reworked.
BTW I brought up some issues regarding the quality parameter and
how it worked some years ago:
https://www.spinics.net/lists/linux-crypto/msg17476.html

I haven't monitored the progress on this one but I recently found
this patch from Theodore that adds an option to skip the CPU's
built-in hwrng (RDRAND).
https://patchwork.kernel.org/patch/10531149/

Since we allow flexibility for the CPU's build-in hwrng, I believe
it's appropriate to at least allow the same level of flexibility for
removable devices as well, even better if the setting can be
modified at runtime as you mention.

--=20
GPG ID: 0xEE878588
As you read this post global entropy rises. Have Fun ;-)
Nick
