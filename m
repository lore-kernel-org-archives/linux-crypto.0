From: Stephan Mueller <smueller@chronox.de>
Subject: Re: AEAD Question
Date: Wed, 26 Oct 2016 18:32:39 +0200
Message-ID: <1536924.VKbsE1YqZP@positron.chronox.de>
References: <CAPSqeoJkTQ72cRaFk+sZGdCELUR6zFBbFdQsZE_B4DF=x374Og@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: linux-crypto@vger.kernel.org
To: Juan Pablo =?ISO-8859-1?Q?Nari=F1o?= Mendoza <jnarino@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:46994 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752263AbcJZQcy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 26 Oct 2016 12:32:54 -0400
In-Reply-To: <CAPSqeoJkTQ72cRaFk+sZGdCELUR6zFBbFdQsZE_B4DF=x374Og@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Mittwoch, 26. Oktober 2016, 18:17:14 CEST schrieb Juan Pablo Nariño 
Mendoza:

Hi Juan,

> Sorry in advance for making what shall be a basic question for this
> list, but I have really ran out of ideas.
> 
> Can someone explain me please, how does the memory layout and sg lists
> work for the IPSec case, with generated IV case?
> 
> As I understand, it is like this (ascii art)
> 
> AD | IV Space | Plain Text | Auth Tag
>  ^                   ^
> 
> asg              sg

The memory layout is correct when using the RFC4106 cipher.

How you partition your physical memory with the SGL is your choice as long as 
your data in the SGL is lined up as you mentioned above.
> 
> But I am having the AD overwritten, and the AUTH tag and encryption is
> not correct? Could someone please point me in the right direction?
> Thank you again

Maybe the src and dst SGL somehow partially overlap?
> 
> Regards
> 
> Juan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Ciao
Stephan
