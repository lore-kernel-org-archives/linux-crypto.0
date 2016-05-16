From: Gadre Nayan <gadrenayan@gmail.com>
Subject: Decrypting data in RX path
Date: Mon, 16 May 2016 17:24:12 +0530
Message-ID: <CAKJ7aR5v5LmgZ5XAv8+9mAtksdSu=LJz=oK9AmHO2t4bDiqSzw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f182.google.com ([209.85.223.182]:32892 "EHLO
	mail-io0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923AbcEPLyN (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 16 May 2016 07:54:13 -0400
Received: by mail-io0-f182.google.com with SMTP id f89so205782976ioi.0
        for <linux-crypto@vger.kernel.org>; Mon, 16 May 2016 04:54:13 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

I am able to encrypt data using the asynchronous kernel crypto API's.
I can observe the encrypted data on the protocol analyzer.

I wanted to decry-pt the data now on the receiver side, So I have
following questions.

1. What is the best place to decrypt the data, in kernel space (module
(pre-routing hook) or driver) OR user space using (maybe using raw
sockets or after socket recv).

What precautions should be taken in terms of locking while using
crypto api's in kernel space in RX path (Softirq context) --> Can
someone point to existing sample in kernel where decryption is done in
RX path.


2. If I encrypt data in kernel space can I decrypt it in User-space
using same encryption methods and Keys.

Thanks.
