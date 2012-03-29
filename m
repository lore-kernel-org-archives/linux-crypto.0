From: Hamid Nassiby <h.nassiby@gmail.com>
Subject: Re: Old PADATA patch vs crypto-2.6 tree
Date: Thu, 29 Mar 2012 23:18:27 +0430
Message-ID: <CAFuf8QMwdPXu4exzLo_Co7MaLxLJCLjragNWsaV=e2q3CjXsfA@mail.gmail.com>
References: <CAFB-WE9o5TDZrxiFz=Lbe=87XdcHw4wEcEwtC3FKJ_DR2_MYCA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org
To: Sebastien Agnolini <sebastien.agnolini@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:63207 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932349Ab2C2Ss7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 29 Mar 2012 14:48:59 -0400
Received: by bkcik5 with SMTP id ik5so2301379bkc.19
        for <linux-crypto@vger.kernel.org>; Thu, 29 Mar 2012 11:48:58 -0700 (PDT)
In-Reply-To: <CAFB-WE9o5TDZrxiFz=Lbe=87XdcHw4wEcEwtC3FKJ_DR2_MYCA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

You must instantiate pcrypt using crconf app or tcrypt module;

On Wed, Mar 28, 2012 at 4:23 PM, Sebastien Agnolini
<sebastien.agnolini@gmail.com> wrote:
>
> Hey,
>
> How activate the IPsec parallelization ?
> I compiled the crypto-2.6 kernel with this param :
> CONFIG_CRYPTO_... =3D y
> CONFIG_PADATA =3D y
> CONFIG_SMP=3Dy
> After installation on 2 servers (IPSEC tunnel), i don't detect the IP=
sec
> parallelization.
> The algorithm is loaded (present in /proc/crypto), but only one core =
works.
>
> So, What are the other parameters that I forgot for the compilation o=
f the
> kernel? IRQ, IO, Scheduler parameters... Am i missing something ?
> I thought that the parallelization was automatically started. True ?
> What are the conditions to observe a parallel work ?
> A "little" documentation will be Welcome.
>
> I'd like compare the bandwidth of my test platform using the =AB old =
=BB PADATA
> patch.
>
> Sebastien
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypt=
o" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
