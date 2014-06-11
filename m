From: Yury Stankevich <urykhy@gmail.com>
Subject: AF_ALG data chunk size
Date: Wed, 11 Jun 2014 20:02:41 +0400
Message-ID: <53987DA1.5020407@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-lb0-f173.google.com ([209.85.217.173]:41716 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810AbaFKQCp (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 11 Jun 2014 12:02:45 -0400
Received: by mail-lb0-f173.google.com with SMTP id 10so4936041lbg.4
        for <linux-crypto@vger.kernel.org>; Wed, 11 Jun 2014 09:02:43 -0700 (PDT)
Received: from dark (ppp91-77-42-12.pppoe.mtu-net.ru. [91.77.42.12])
        by mx.google.com with ESMTPSA id b6sm21912848laa.20.2014.06.11.09.02.42
        for <linux-crypto@vger.kernel.org>
        (version=TLSv1.2 cipher=RC4-SHA bits=128/128);
        Wed, 11 Jun 2014 09:02:43 -0700 (PDT)
Received: from elf.dark ([10.103.10.3])
	by dark with esmtpsa (TLS1.0:DHE_RSA_AES_128_CBC_SHA1:128)
	(mail-daemon)
	id 1Wukz4-0004Sn-8P
	for linux-crypto@vger.kernel.org; Wed, 11 Jun 2014 20:02:42 +0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello,

i'm playing a bit with AF_ALG and found a strange problem: it looks like
big data chunks (64K) can lead to error.


what i do:
1. take a file, read some data (8 or 64K), encrypt, write to
crypted-file, repeat until EOF.
2. read crypted-file, with the same chunk size, decrypt, write to
result-file, repeat until EOF.
3. compare results, and they equal for 8K block size, but differ for 64K
block size. to feed data - i use sendmsg/read calls.


steps to reproduce:
1. clone code from [1]
2. vim crypto.cpp
3. edit read_size to `64 * 1024`
4. make
5. ./test.sh
6. show bug place: xxd crypto X-1; xxd L-decrypt X-2; vimdiff X-1 X-2


system information:
kernel 3.15/x86_64
gcc 4.8.2

[1] - https://github.com/urykhy/avoidSSL

ps: please, CC'me on reply

-- 
Linux registered user #402966 // pub 1024D/E99AF373 <pgp.mit.edu>
