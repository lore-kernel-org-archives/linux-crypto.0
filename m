From: Marek Vasut <marex@denx.de>
Subject: Re: Regarding Porting of hardware cryptography to Linux kernel
Date: Fri, 23 Jun 2017 20:13:51 +0200
Message-ID: <1f623a19-10aa-b83b-8b0b-e490b34e60fc@denx.de>
References: <CALWoFifFJVxnCX+_aq40zOdeZh86Gri47pP8oTmcFHAc-VjO_A@mail.gmail.com>
 <d96aa776-6693-8824-7da5-0487a6687169@denx.de>
 <CALWoFifTrdDP3jCR037JgnaR-Q3A4-EKVrb_TQxnKpEfdbvbng@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: sagar khadgi <sagar.khadgi@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:53732 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754327AbdFWSci (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 23 Jun 2017 14:32:38 -0400
In-Reply-To: <CALWoFifTrdDP3jCR037JgnaR-Q3A4-EKVrb_TQxnKpEfdbvbng@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 06/23/2017 07:16 AM, sagar khadgi wrote:
> Hi Marek,

Hi,

> Thanks for replying.
> 
> Regarding Hardware:
> 
> I am using Xilinx zynq FPGA with Athena Core which as AES, RSA, DSA,
> ECDSA, NRBG etc feature.
> I am trying to integrate with Linux kernal. Can you please tell me is
> there any document/example project/link which I can refer.

Yes, see the link I posted in my previous email. Moreover, you can look
into the drivers in the Linux kernel and inspire yourself there.

> Thanks and regards,
> Sagar
> 
> 
> 
> On Thu, Jun 22, 2017 at 5:27 PM, Marek Vasut <marex@denx.de
> <mailto:marex@denx.de>> wrote:
> 
>     On 06/22/2017 01:50 PM, sagar khadgi wrote:
>     > Hi Marek,
> 
>     Hi,
> 
>     > I am having one microcontroller which has AES, HMAC, SHA, DES, RSA, DSA,
>     > ECDSA cryptographic services. I want to port it to Linux Kernal so that
>     > I can access them through OpenSSL from user space.
>     >
>     > I am new to Linux. Can you please provide me any document or link for
>     > porting the hardware cryptography to Linux kernel.
> 
>     Try https://www.kernel.org/doc/html/v4.11/crypto/index.html
>     <https://www.kernel.org/doc/html/v4.11/crypto/index.html>
> 
>     unless you provide further details about your hardware, it's hard to
>     help you more.
> 
>     > Thanking you in advance.
>     >
>     > Regards,
>     > Sagar
> 
> 
>     --
>     Best regards,
>     Marek Vasut
> 
> 


-- 
Best regards,
Marek Vasut
