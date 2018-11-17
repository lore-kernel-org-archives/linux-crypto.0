Return-Path: <SRS0=r3Tc=N4=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-ot1-f67.google.com ([209.85.210.67]:42933 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725854AbeKQUKH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 17 Nov 2018 15:10:07 -0500
MIME-Version: 1.0
References: <20181023144654.12906-1-andrew.shadura@collabora.co.uk>
 <d848f97e-a9fc-1562-1963-3b608162106d@collabora.co.uk> <nycvar.YFH.7.76.1811121217030.27368@cbobk.fhfr.pm>
 <96148aff-eac8-7e25-dd74-b194b7bae025@collabora.co.uk>
In-Reply-To: <96148aff-eac8-7e25-dd74-b194b7bae025@collabora.co.uk>
From: Nick Kossifidis <mickflemm@gmail.com>
Date: Sat, 17 Nov 2018 11:53:45 +0200
Message-ID: <CAFtRNNyZgue5O=3wVxznYgGg-zM4TGa5na4SJRexyAZ7KWD82g@mail.gmail.com>
Subject: Re: [PATCH] HID: add driver for U2F Zero built-in LED and RNG
To: andrew.shadura@collabora.co.uk
Cc: jikos@kernel.org, linux-input@vger.kernel.org,
        linux-usb@vger.kernel.org, kernel@collabora.com,
        anarsoul@gmail.com, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

=CE=A3=CF=84=CE=B9=CF=82 =CE=A4=CE=B5=CF=84, 14 =CE=9D=CE=BF=CE=B5 2018 =CF=
=83=CF=84=CE=B9=CF=82 8:33 =CE=BC.=CE=BC., =CE=BF/=CE=B7 Andrej Shadura
<andrew.shadura@collabora.co.uk> =CE=AD=CE=B3=CF=81=CE=B1=CF=88=CE=B5:
>
> On 12/11/2018 03:17, Jiri Kosina wrote:
> > On Thu, 1 Nov 2018, Andrej Shadura wrote:
> >
> >> Hi everyone,
> >>
> >> I=E2=80=99ve got a comment from Nick Kossifidis that I probably should=
n=E2=80=99t set
> >> RNG=E2=80=99s quality to 1024. Adding linux-crypto@ to the loop.
> >
> > So, what was this about? Is there any resolution to it? :)
>
> So far, not really. I talked to Keith Packard regarding a similar
> setting in his ChaosKey driver, and I understand his opinion is that it
> is appropriate there since he=E2=80=99s convinced about the quality of th=
e
> hardware he designed. I=E2=80=99m not sure what exactly I should set it t=
o here.
>

The issue is not how good the ChaosKey is but how sure he is that what
gets plugged in is indeed a ChaosKey and not something else that e.g.
outputs only 0s. I suggest that all removable hwrngs are zero-credit
by default, those that will use them will most probably be ok with
changing a setting, verifying in a sense that they are aware of what's
plugged in.


--=20
GPG ID: 0xEE878588
As you read this post global entropy rises. Have Fun ;-)
Nick
