From: Gadre Nayan <gadrenayan@gmail.com>
Subject: Re: Decrypting data in RX path
Date: Mon, 16 May 2016 17:41:19 +0530
Message-ID: <CAKJ7aR5AOsXD7qVhJRMATn8K6oevXUB36cdD0=oasD52uh-EhA@mail.gmail.com>
References: <CAKJ7aR5v5LmgZ5XAv8+9mAtksdSu=LJz=oK9AmHO2t4bDiqSzw@mail.gmail.com>
	<HE1PR04MB1306ADC0ADE1CB57D2AB4A7CEE770@HE1PR04MB1306.eurprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Catalin Vasile <cata.vasile@nxp.com>, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f174.google.com ([209.85.223.174]:36573 "EHLO
	mail-io0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787AbcEPMLV (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 16 May 2016 08:11:21 -0400
Received: by mail-io0-f174.google.com with SMTP id i75so201400147ioa.3
        for <linux-crypto@vger.kernel.org>; Mon, 16 May 2016 05:11:20 -0700 (PDT)
In-Reply-To: <HE1PR04MB1306ADC0ADE1CB57D2AB4A7CEE770@HE1PR04MB1306.eurprd04.prod.outlook.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

[Catalin Vasile] What do you mean by "using same encryption methods" ?

What I meant was, in the module If I use "cbc(aes)" With say 16 blocks
of data to be encrypted with 16 bytes of iv-data and so on, are there
user space Api's to use in decryption which will take such arguments,
otherwise data won't be decrypted properly ?

On Mon, May 16, 2016 at 5:34 PM, Catalin Vasile <cata.vasile@nxp.com> wrote:
> Inline comments.
>
> ________________________________________
> From: linux-crypto-owner@vger.kernel.org <linux-crypto-owner@vger.kernel.org> on behalf of Gadre Nayan <gadrenayan@gmail.com>
> Sent: Monday, May 16, 2016 2:54 PM
> To: linux-crypto@vger.kernel.org
> Subject: Decrypting data in RX path
>
> Hi,
>
> I am able to encrypt data using the asynchronous kernel crypto API's.
> I can observe the encrypted data on the protocol analyzer.
>
> I wanted to decry-pt the data now on the receiver side, So I have
> following questions.
>
> 1. What is the best place to decrypt the data, in kernel space (module
> (pre-routing hook) or driver) OR user space using (maybe using raw
> sockets or after socket recv).
>
> What precautions should be taken in terms of locking while using
> crypto api's in kernel space in RX path (Softirq context) --> Can
> someone point to existing sample in kernel where decryption is done in
> RX path.
> [Catalin Vasile] Look into net/ipv6/esp6.c. It's related to IPsec.
>
> 2. If I encrypt data in kernel space can I decrypt it in User-space
> using same encryption methods and Keys.
> [Catalin Vasile] What do you mean by "using same encryption methods" ?
>
> Thanks.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
