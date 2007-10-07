From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: [PATCH] [crypto] load the SHA1[1|256] module by an alias (v2)
Date: Sun, 7 Oct 2007 23:42:27 +0200
Message-ID: <20071007214227.GA25656@Chamillionaire.breakpoint.cc>
References: <E1IMveX-0002Kv-00@gondolin.me.apana.org.au> <20070820101618.GE16680@bingen.suse.de> <20070820120605.GA13163@gondor.apana.org.au> <20070930124239.GB24811@Chamillionaire.breakpoint.cc> <20071003073522.GA7285@gondor.apana.org.au> <20071004083512.GA11305@Chamillionaire.breakpoint.cc> <E1IdMSX-0004KV-LS@Chamillionaire.breakpoint.cc> <20071005085744.GC10959@gondor.apana.org.au> <E1IdnjO-0006eu-JQ@Chamillionaire.breakpoint.cc> <20071005151051.GA13666@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:46445 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754710AbXJGVm3 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 7 Oct 2007 17:42:29 -0400
Content-Disposition: inline
In-Reply-To: <20071005151051.GA13666@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

* Herbert Xu | 2007-10-05 23:10:51 [+0800]:

>BTW, the dead-lock does exist after all.  The lock that's held
>is the user-space file lock held by modprobe.  Assuming that
>padlock-sha comes before sha in the alias list, then the second
>modprobe will hit padlock-sha again and dead-lock.

I tried to deadlock and I did not succeed, maybe I did something wrong.

# fgrep sha modules.alias 
alias sha256 padlock_sha
alias sha1 padlock_sha
alias sha384 sha512
alias sha256 sha256_generic
alias sha1 sha1_generic

padlock comes first as you said. A "modprobe tcrypt mode=2" worked fine
(with the test passed).

# lsmod |grep sha
sha1_generic            3008  0 
padlock_sha             4160  0 
crypto_algapi          13824  4
sha1_generic,padlock_sha,blkcipher,cryptomgr

I have a version of the padlock-sha driver with no HW dependency
(fallback only, that one I used) at

  git://git.breakpoint.cc/bigeasy/linux via_sha

if you want to test :)


>Cheers,

Sebastian
