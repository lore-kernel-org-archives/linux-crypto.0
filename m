Return-Path: <SRS0=DMoR=WX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1F65C3A5A3
	for <linux-crypto@archiver.kernel.org>; Tue, 27 Aug 2019 14:06:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8B9A1206E0
	for <linux-crypto@archiver.kernel.org>; Tue, 27 Aug 2019 14:06:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gnQSOyAn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726596AbfH0OGU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 27 Aug 2019 10:06:20 -0400
Received: from mail-oi1-f177.google.com ([209.85.167.177]:38885 "EHLO
        mail-oi1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726134AbfH0OGU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 27 Aug 2019 10:06:20 -0400
Received: by mail-oi1-f177.google.com with SMTP id q8so14736768oij.5
        for <linux-crypto@vger.kernel.org>; Tue, 27 Aug 2019 07:06:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=/UGGysTqJwrWJMF1ubGUeTFN3t4lq8dUsfXMvyyBWEY=;
        b=gnQSOyAnGppz8qR8meRJ57g+3n2Luk+CairIqV/+A81231uilnO/YvIrsClAYc8fNh
         nBIRF2FrpBXJvXIBWdcZ+CJrTNoveylqi5jwoeghp/Yb8cAWozYPGSX8zZXdtZGRSlrA
         gp9YjTd5ETzygFEugdiXG8tITUbw2Uta3b9LtBryt4dCBteZGUWhC0Z4xHxVbwF6tEJ4
         7lys2aHBfCSuE/1E6CpHKXobiuuc2TMcCpHsU+YLM+sQIuaUutzwDZWgARwcAidoeCEf
         riw+AjznVw+ieQ/yskeGXF2sXxgxWQsVjpv9qm2qt8auzqsH/Ev/N3xqfzt+qucNilZS
         85QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=/UGGysTqJwrWJMF1ubGUeTFN3t4lq8dUsfXMvyyBWEY=;
        b=o/Utn8S0KhwAWd4JVWGPqJJjES+lrCJ0s64xkhFdVV11UIB86bXz8F3CI/qqrMzopm
         a7AmYQF/sz54xAyyD8S1tXmRsKkQ7rtrVBx3o9BQTkehvd6Tb1evdw66q1URWFM9Zaj1
         OdgFL1a+m+g1wq4DeufGqoimqqRsnBPhP4V/QCiCYYurbLXiHjo+VEN2QKa3nWcCV/eY
         0HcbCTOx5TfvmXD+0MC6jzg4N8VtJdGuQuK7865W858sPUQZf1EKGwyL5srvt50foeb7
         ymm2NbS+cMfiiOtCW9UjonhFFd4R4YUq1ZJTGg+mqBJVlJ08BzaUkiKVrCnuhR8H+EWU
         TzMA==
X-Gm-Message-State: APjAAAVWR0FIAC/iSDoUlh428MZyWn/rXSygj4vK/thYk6AJXVws5V5W
        B2/v5INp+3Jb+thmXb2zp2OxaVBMeF+dusLx0VJfoaCAvSs=
X-Google-Smtp-Source: APXvYqzZeN5cuxn6ijuB1B8JUkG/cGMT6WZhGlfvOu2SLFxq5zQrbGpE1ndCaD4BpBGXO9gue0gunfh7WM2rqtXEVi4=
X-Received: by 2002:aca:cd41:: with SMTP id d62mr16026188oig.78.1566914778514;
 Tue, 27 Aug 2019 07:06:18 -0700 (PDT)
MIME-Version: 1.0
References: <CANaw-r4i6qHXYNDFu5dZ4DsHedyPonk5N+-F9Mu4JvLRrD50sQ@mail.gmail.com>
 <d20ab826-5a7a-e0e4-6591-4c7d4bdae5d8@c-s.fr> <CANaw-r59BwhwvHOLqtOjBJdrOzMbgENCG1a6QKKbwMOCLKVF2A@mail.gmail.com>
In-Reply-To: <CANaw-r59BwhwvHOLqtOjBJdrOzMbgENCG1a6QKKbwMOCLKVF2A@mail.gmail.com>
From:   Mukul Joshi <mukuljoshi2011@gmail.com>
Date:   Tue, 27 Aug 2019 10:05:42 -0400
Message-ID: <CANaw-r7HkFH=O6h5DuE2qNoNcvd7otKAq8ahavJeMoZgX7d00g@mail.gmail.com>
Subject: Fwd: Data size error interrupt with Talitos driver on 4.9.82 kernel
To:     linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Christophe,

Thanks for your email.
One thing I forgot to mention is that I am running a RT kernel, 4.9.82
with rt76 patches applied to it.
I am not sure if that can play any role in this issue.

Yes, I have the crypto tests activated at boot time. All the ones that
have their corresponding tests are passing.
There are a few for which I see "No test for ...."
[    2.582100] alg: No test for authenc(hmac(sha224),cbc(aes))
(authenc-hmac-sha224-cbc-aes-talitos)
[    2.584094] alg: No test for authenc(hmac(sha224),cbc(aes))
(authenc-hmac-sha224-cbc-aes-talitos)
[    2.606097] alg: No test for authenc(hmac(md5),cbc(aes))
(authenc-hmac-md5-cbc-aes-talitos)
[    2.608094] alg: No test for authenc(hmac(md5),cbc(aes))
(authenc-hmac-md5-cbc-aes-talitos)
[    2.610077] alg: No test for authenc(hmac(md5),cbc(des3_ede))
(authenc-hmac-md5-cbc-3des-talitos)
[    2.612076] alg: No test for authenc(hmac(md5),cbc(des3_ede))
(authenc-hmac-md5-cbc-3des-talitos)
[  237.271903] alg: No test for
echainiv(authenc(hmac(md5),cbc(des3_ede)))
(echainiv(authenc-hmac-md5-cbc-3des-talitos))

I also dumped the CCPSR register and it indicates EU error:
[  375.872689] talitos e0030000.crypto: Ch: 2, CCPSR 0x01000007_023c0104
[  375.872708] talitos e0030000.crypto: DEUISR 0x00000000_00000100
[  375.872719] talitos e0030000.crypto: DEUDSR 0x00000000_00000320
[  375.872730] talitos e0030000.crypto: DEURCR 0x00000000_00000000
[  375.872741] talitos e0030000.crypto: DEUSR 0x00000000_00000025
[  375.872752] talitos e0030000.crypto: DEUICR 0x00000000_00003000
[  375.872763] talitos e0030000.crypto: DEUMR 0x00000000_00000006
[  375.872775] talitos e0030000.crypto: DEUKSR 0x00000000_00000018
[  375.872786] talitos e0030000.crypto: MDEUISR 0x00000000_00000000
[  375.872797] talitos e0030000.crypto: DESCBUF 0x20635e0b_00000000
[  375.872808] talitos e0030000.crypto: DESCBUF 0x00100000_0cc74d3c
[  375.872819] talitos e0030000.crypto: DESCBUF 0x00100000_1d0355a6
[  375.872831] talitos e0030000.crypto: DESCBUF 0x00080000_12a80b80
[  375.872842] talitos e0030000.crypto: DESCBUF 0x00180000_0cc74d4c
[  375.872853] talitos e0030000.crypto: DESCBUF 0x00640000_1d0355b6
[  375.872864] talitos e0030000.crypto: DESCBUF 0x00580c00_1d0355b6
[  375.872875] talitos e0030000.crypto: DESCBUF 0x00080000_0cc74ddc

I do not have FIPS enabled.

The same hardware running 3.14.68 kernel does not have any issues with
IPsec/talitos driver and I can see pings going through.
Obviously, the talitos driver has evolved after 3.14.68 version.

I have plans to move to 4.9.190 but it will involve some effort since
I would have to port a lot of other stuff which I have working on
4.9.82.
Sorry but I would prefer to stick to 4.9.82 for now and try and debug
this issue unless I know a similar/same issue was fixed after 4.9.82.
If there are no clues to this issue, then I may have to try and move
to 4.9.190 version.

Are you aware of some changes that went in after 4.9.82 that could
cause this issue to go away?
Who is responsible for writing the data size in the EU Data size
register and what could cause it to be written with a value which is
not a multiple of 64-bits?

Any other pointers on debugging this while still remaining on 4.9.82 kernel=
?

Thanks,
Mukul




On Mon, Aug 26, 2019 at 2:57 AM Christophe Leroy
<christophe.leroy@c-s.fr> wrote:
>
> Hi Mukul
>
> Le 24/08/2019 =C3=A0 18:40, Mukul Joshi a =C3=A9crit :
> > Hi Christophe,
>
> [...]
>
> >
> > I am working with MPC8360E SoC  and trying to setup IPSEC tunnel betwee=
n
> > 2 hosts.
> > I am able to setup the tunnel but I am seeing issues with packet
> > decryption. The sender side doesn't seem to have a problem and the
> > packet is also being encrypted by the EU.
> >
> > Upon reception of packet, I am seeing Data size error interrupt go up i=
n
> > the Interrupt status register of the EU.
> > I see the problem with both AES and 3DES algos.
> >
> > Here are the logs that I see in dmesg:
> > AES:
> > [  832.041102] talitos e0030000.crypto: AESUISR *0x00000000_00000100*
> > [  832.041120] talitos e0030000.crypto: MDEUISR 0x00000000_00000000
> > [  832.041131] talitos e0030000.crypto: DESCBUF 0x60235c0b_00000000
> > [  832.041142] talitos e0030000.crypto: DESCBUF 0x00140000_0c8d353c
> > [  832.041154] talitos e0030000.crypto: DESCBUF 0x00180000_12f57920
> > [  832.041165] talitos e0030000.crypto: DESCBUF 0x00100000_144e3e40
> > [  832.041176] talitos e0030000.crypto: DESCBUF 0x00100000_0c8d3550
> > [  832.041188] talitos e0030000.crypto: DESCBUF 0x006c0000_12f57938
> > [  832.041199] talitos e0030000.crypto: DESCBUF 0x00600c00_12f57938
> > [  832.041210] talitos e0030000.crypto: DESCBUF 0x00100000_0c8d35dc
> >
> > 3DES:
> > [ 313.635521] talitos e0030000.crypto: DEUISR *0x00000000_00000100*
> >   [  313.635539] talitos e0030000.crypto: DEUDSR *0x00000000_00000320*
> >   [  313.635549] talitos e0030000.crypto: DEURCR 0x00000000_00000000
> >   [  313.635560] talitos e0030000.crypto: DEUSR 0x00000000_00000025
> >   [  313.635572] talitos e0030000.crypto: DEUICR 0x00000000_00003000
> >   [  313.635583] talitos e0030000.crypto: MDEUISR 0x00000000_00000000
> >   [  313.635594] talitos e0030000.crypto: DESCBUF 0x20635e0b_00000000
> >   [  313.635605] talitos e0030000.crypto: DESCBUF 0x00100000_1abbc03c
> >   [  313.635617] talitos e0030000.crypto: DESCBUF 0x00100000_1ef2f226
> >   [  313.635628] talitos e0030000.crypto: DESCBUF 0x00080000_1abbdc80
> >   [  313.635639] talitos e0030000.crypto: DESCBUF 0x00180000_1abbc04c
> >   [  313.635650] talitos e0030000.crypto: DESCBUF 0x00640000_1ef2f236
> > [  313.635726] talitos e0030000.crypto: DESCBUF 0x00580c00_1ef2f236
> >   [  313.635738] talitos e0030000.crypto: DESCBUF 0x00080000_1abbc0dc
> >
> > I was able to dump the data size register value for DES and it shows a
> > value of 0x320 in LO word.
> > This shows that the Data size for decryption is not 64-bit multiple
> > which causes the Data size error interrupt to go up but I don't know ho=
w
> > this value gets written and why is the value as 0x320 when the the
> > tcpdump on the receive side shows a packet size of 112 bytes of
> > encrypted packets received.
>
> Yes that's strange. The pointers in the descriptors dumped above all
> have valid size. The input data has size 0x64 ie 100 bytes, and the
> output data has size 88 + 12 bytes HMAC out.
>
> Have you activated crypto tests at boot time ? Do they all pass ?
>
> Can you have a look at CCPSR register ?
>
> >
> > Can you please give me a few pointers about what could be causing this
> > issue and where else can I look further.
>
> Can you try with kernel 4.9.190 ?
>
> Have you tried with a newer LTS kernel, for instance 4.14.x or 4.19.x ?
>
> Christophe
