From: Harsh Jain <Harsh@chelsio.com>
Subject: Updated IV for XTS
Date: Fri, 8 Sep 2017 16:17:54 +0530
Message-ID: <e1a9f8a6-37d5-2cec-a1f1-dacd5e357e92@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
To: Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org, Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:55127 "EHLO l.chelsio.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751548AbdIHKsG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 Sep 2017 06:48:06 -0400
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

XTS template does not seems updating the IV after request completion. Same output if we run belwo command in loop

[root@heptagon test]# ./kcapi -x 1 -d 4 -s  -e -c "xts(aes)" -i 7fbc02ebf5b93322329df9bfccb635af -k 8d7dd9b0170ce0b5f2f8e1aa768e01e91da8bfc67fd486d081b28254c99eb423 -p `perl -e 'print "e" x  32'`
4ea328cd5b10d0cb3bbc7ab92d54072d
4ea328cd5b10d0cb3bbc7ab92d54072d
4ea328cd5b10d0cb3bbc7ab92d54072d
4ea328cd5b10d0cb3bbc7ab92d54072d

Is IV update not required for XTS as we did for cbc,ctr mode.

Regards
Harsh Jain
