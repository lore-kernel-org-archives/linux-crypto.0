From: Guruswamy Basavaiah <guru2018@gmail.com>
Subject: [Question] Queuing packets to work queue ablk_helper.c and packets
 getting reordered.
Date: Mon, 14 Jul 2014 14:58:39 +0530
Message-ID: <CAHSpA5-7Nph-1C_nQjLLEkMFmVLEinw3FaTfGa6D8meexBY9Yw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:60688 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349AbaGNJ2k (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 14 Jul 2014 05:28:40 -0400
Received: by mail-pa0-f46.google.com with SMTP id eu11so5058073pac.19
        for <linux-crypto@vger.kernel.org>; Mon, 14 Jul 2014 02:28:39 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,
 Noticed this issue in linux-2.6.34.14 and its same in linux-3.14.4.

 In ablk_decrypt, we check may_use_simd() function to decrypt the
packet. If may_use_simd() function returns true, we get the packet
decrypted immediately and return. If it return false packet will be
queued for decryption.

When queue already have packets for decryption, if for a incoming
packet "may_use_simd()" function returns true, the packet will get
decrypted immediately and returned with out checking the packets in
queue.

So the packets in the queue will be send to upper layer or forwarded
late, resulting in the reordering of the packets.

Is this fine?  my understanding was packets will be never be reorder
in the ipsec layer in kernel.
Let me know if question is not clear, i will try to frame it better.

Please include my email id in the response
-- 
Guruswamy Basavaiah
