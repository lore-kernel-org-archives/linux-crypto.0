From: sri sowj <srisowj4linux@gmail.com>
Subject: Understanding HASH(SHA) Driver implementation
Date: Sat, 14 Feb 2015 00:01:34 +0530
Message-ID: <CAHTT9VLBM6Vkm4L5TZX9sEv2EZVyvbMwfBgLB7Kv2q=ZDeC1ug@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ie0-f196.google.com ([209.85.223.196]:33930 "EHLO
	mail-ie0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665AbbBMSbf (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 13 Feb 2015 13:31:35 -0500
Received: by iecar1 with SMTP id ar1so2178670iec.1
        for <linux-crypto@vger.kernel.org>; Fri, 13 Feb 2015 10:31:34 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi ,

I am trying to analyze Linux Kernel Crypto Interface with respective
to hashing(ahash for SHA1 in particular) . I am looking at
omap-sham.c/atmel-sha.c as reference,which is in open source
linux/driver/crypto.I need some inputs in understanding following .

#1: If It need to handle a scenario where in which multiple messages
will be given to generate a digest/Hash message like below.

Ex:  Input Block =  buffer1 + buffer2 +.... +buffern

if I need to generate hash for Input Block(could be anything like a
fwimage/file etc) , Then I ll split it into some buffers and I ll send
it
in chunks like buffer1,bffer2 etc to underlying crypto driver


Hash( Input Block) = Hash(buffer1) + Hash(buffer2) + ..... + Hash( buffern)
                                   |                       |
    + ..... +    |
                                   |                       |
                   |
                               sha_update(*)      sha_update(*)
 sha_update(*)


How is it possible to keep track/store intermediate Hash generated data
like for buffer1,buffer2 etc ?

#2: what is the need to have multiple structures like  "*_sha_reqctx "
and "*_sha_dev" ?

As Per my understanding "*_sha_reqctx" structure  is for generic Linux
Kernel Crypto crypto context to interact with specific crypto request
and
"*_sha_dev" structure is for Hardware specific some thing like for any
DMA related operations.

BR,
Srisowj
