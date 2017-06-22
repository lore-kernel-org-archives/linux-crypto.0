From: Marek Vasut <marex@denx.de>
Subject: Re: Regarding Porting of hardware cryptography to Linux kernel
Date: Thu, 22 Jun 2017 13:57:55 +0200
Message-ID: <d96aa776-6693-8824-7da5-0487a6687169@denx.de>
References: <CALWoFifFJVxnCX+_aq40zOdeZh86Gri47pP8oTmcFHAc-VjO_A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: sagar khadgi <sagar.khadgi@gmail.com>, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:35197 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750847AbdFVL6A (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Jun 2017 07:58:00 -0400
In-Reply-To: <CALWoFifFJVxnCX+_aq40zOdeZh86Gri47pP8oTmcFHAc-VjO_A@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 06/22/2017 01:50 PM, sagar khadgi wrote:
> Hi Marek,

Hi,

> I am having one microcontroller which has AES, HMAC, SHA, DES, RSA, DSA,
> ECDSA cryptographic services. I want to port it to Linux Kernal so that
> I can access them through OpenSSL from user space.
> 
> I am new to Linux. Can you please provide me any document or link for
> porting the hardware cryptography to Linux kernel.

Try https://www.kernel.org/doc/html/v4.11/crypto/index.html

unless you provide further details about your hardware, it's hard to
help you more.

> Thanking you in advance.
> 
> Regards,
> Sagar


-- 
Best regards,
Marek Vasut
