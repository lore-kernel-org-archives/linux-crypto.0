From: Stephan Mueller <smueller@chronox.de>
Subject: Re: Updated IV for XTS
Date: Fri, 08 Sep 2017 13:02:54 +0200
Message-ID: <1653545.QqfHqHTgVp@tauon.chronox.de>
References: <e1a9f8a6-37d5-2cec-a1f1-dacd5e357e92@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org
To: Harsh Jain <Harsh@chelsio.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34666 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751577AbdIHLC6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 Sep 2017 07:02:58 -0400
In-Reply-To: <e1a9f8a6-37d5-2cec-a1f1-dacd5e357e92@chelsio.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Freitag, 8. September 2017, 12:47:54 CEST schrieb Harsh Jain:

Hi Harsh,

> Hi,
> 
> XTS template does not seems updating the IV after request completion. Same
> output if we run belwo command in loop
> 
> [root@heptagon test]# ./kcapi -x 1 -d 4 -s  -e -c "xts(aes)" -i
> 7fbc02ebf5b93322329df9bfccb635af -k
> 8d7dd9b0170ce0b5f2f8e1aa768e01e91da8bfc67fd486d081b28254c99eb423 -p `perl
> -e 'print "e" x  32'` 4ea328cd5b10d0cb3bbc7ab92d54072d
> 4ea328cd5b10d0cb3bbc7ab92d54072d
> 4ea328cd5b10d0cb3bbc7ab92d54072d
> 4ea328cd5b10d0cb3bbc7ab92d54072d
> 
> Is IV update not required for XTS as we did for cbc,ctr mode.
> 
> Regards
> Harsh Jain

Hm, are you sure you sent the right command?

../bin/kcapi -x 1 -d 4 -s  -e -c "xts(aes)" -i 
7fbc02ebf5b93322329df9bfccb635af -k 
8d7dd9b0170ce0b5f2f8e1aa768e01e91da8bfc67fd486d081b28254c99eb423 -p `perl -e 
'print "e" x  32'`
4ea328cd5b10d0cb3bbc7ab92d54072d
24c7c1967a3768a17ff0afe976381a79
5b23fff5d3a5c75090229e5b9ad807e7
ffc8927be32448f2ba67bbe6e0087805

vs

../bin/kcapi -x 1 -d 4 -e -c "xts(aes)" -i 7fbc02ebf5b93322329df9bfccb635af -k 
8d7dd9b0170ce0b5f2f8e1aa768e01e91da8bfc67fd486d081b28254c99eb423 -p `perl -e 
'print "e" x  32'`
4ea328cd5b10d0cb3bbc7ab92d54072d
4ea328cd5b10d0cb3bbc7ab92d54072d
4ea328cd5b10d0cb3bbc7ab92d54072d
4ea328cd5b10d0cb3bbc7ab92d54072d


The key difference is the -s -- the stream mode.

Note that only the stream mode API of libkcapi "keeps the cipher handle open" 
(i.e. and thus the state).

The "one-shot" API does one complete cipher operation and kills the state.

See http://www.chronox.de/libkcapi/html/Usage.html#idm140613614152864 for 
details.

Ciao
Stephan
