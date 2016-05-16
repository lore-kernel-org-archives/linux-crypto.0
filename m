From: Stephan Mueller <smueller@chronox.de>
Subject: Re: Decrypting data in RX path
Date: Mon, 16 May 2016 14:32:44 +0200
Message-ID: <6061728.aByMvLa2kt@tauon.atsec.com>
References: <CAKJ7aR5v5LmgZ5XAv8+9mAtksdSu=LJz=oK9AmHO2t4bDiqSzw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: Gadre Nayan <gadrenayan@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.atsec.com ([195.30.99.214]:36422 "EHLO mail.atsec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750787AbcEPMkp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 16 May 2016 08:40:45 -0400
Received: from mail.atsec.com (localhost [127.0.0.1])
	by mail.atsec.com (Postfix) with ESMTP id D3E6E212CA
	for <linux-crypto@vger.kernel.org>; Mon, 16 May 2016 14:32:46 +0200 (CEST)
In-Reply-To: <CAKJ7aR5v5LmgZ5XAv8+9mAtksdSu=LJz=oK9AmHO2t4bDiqSzw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 16. Mai 2016, 17:24:12 schrieb Gadre Nayan:

Hi Gadre,

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

This is a very broad question and cannot be answered without knowning the 
context.
> 
> What precautions should be taken in terms of locking while using
> crypto api's in kernel space in RX path (Softirq context) --> Can
> someone point to existing sample in kernel where decryption is done in
> RX path.

net/ipv4/esp4.c:esp_input for rx and esp_output for tx.
> 
> 
> 2. If I encrypt data in kernel space can I decrypt it in User-space
> using same encryption methods and Keys.

Sure, if you have the keys and all information about the used crypto.
> 
> Thanks.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Ciao
Stephan
