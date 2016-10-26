From: Hamid Nassiby <h.nassiby@gmail.com>
Subject: Re: ARM-CE aes encryption on uneven blocks
Date: Wed, 26 Oct 2016 10:46:41 +0330
Message-ID: <CAFuf8QPCZPaLXh0nNY3Ktm-w6STKGwXpTEQcXGH-HCDvWD-jLQ@mail.gmail.com>
References: <HE1PR04MB13065DBD6C9844835123FAF9EEA90@HE1PR04MB1306.eurprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Cata Vasile <cata.vasile@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:36855 "EHLO
        mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753696AbcJZHRP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 26 Oct 2016 03:17:15 -0400
Received: by mail-wm0-f43.google.com with SMTP id b80so207478198wme.1
        for <linux-crypto@vger.kernel.org>; Wed, 26 Oct 2016 00:17:14 -0700 (PDT)
In-Reply-To: <HE1PR04MB13065DBD6C9844835123FAF9EEA90@HE1PR04MB1306.eurprd04.prod.outlook.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

Based on my old experience with "struct crypto_alg" based drivers, the
data you receive there, is padded beforehand(in the upper layers);
Therefore the plaintext contains integral multiple of AES block size
of data and based on the number of blocks, the crypto transform can be
computed.

Regards,
Hamid

On Mon, Oct 24, 2016 at 6:11 PM, Cata Vasile <cata.vasile@nxp.com> wrote:
>
> Hi,
>
> I'm trying to understand the code for AES encryption from ARM-CE.
> From the aes-glue.S calls I understand that the encryption primitives receive the number of blocks, but have no way of determining the number of bytes to encrypt, if for example the plaintext does not have a length of a multiple of AES block size.
> How does, for example, ecb_encrypt() also encrypt the last remaining bytes in the plaintext if it is not a multiple of AES block size if It can never deduce the full plaintext size?
>
> Catalin Vasile--
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
