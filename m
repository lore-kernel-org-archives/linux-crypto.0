From: Eric Biggers <ebiggers@google.com>
Subject: Re: Crash in crypto mcryptd
Date: Thu, 1 Dec 2016 23:06:58 -0800
Message-ID: <20161202070658.GA18690@google.com>
References: <alpine.LRH.2.02.1612011819540.27565@file01.intranet.prod.int.rdu2.redhat.com>
 <1480643222.3064.52.camel@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: Mikulas Patocka <mpatocka@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, dm-devel@redhat.com,
        Milan Broz <mbroz@redhat.com>,
        Megha Dey <megha.dey@linux.intel.com>
To: Tim Chen <tim.c.chen@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f48.google.com ([74.125.83.48]:33960 "EHLO
        mail-pg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752143AbcLBHHD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 2 Dec 2016 02:07:03 -0500
Received: by mail-pg0-f48.google.com with SMTP id x23so104476655pgx.1
        for <linux-crypto@vger.kernel.org>; Thu, 01 Dec 2016 23:07:03 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1480643222.3064.52.camel@linux.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Dec 01, 2016 at 05:47:02PM -0800, Tim Chen wrote:
> On Thu, 2016-12-01 at 19:00 -0500, Mikulas Patocka wrote:
> > Hi
> > 
> > There is a bug in mcryptd initialization.
> > 
> > This is a test module that tries various hash algorithms. When you load 
> > the module with "insmod test.ko 'alg=mcryptd(md5)'", the machine crashes.
> 
> I don't think your test setup is right.  The mcryptd supports only multi-buffer
> algorithm.  I don't think there is such an implementation for md5.
> 
> Please refer to arch/x86/crypto/sha1-mb 
> multi-buffer implementation of sha1 to see the proper
> setup and usage with mcryptd.  You can also run tcrypt test to
> exercise this code.
> 
> Tim

No, mcryptd must not crash the kernel if it's passed the wrong algorithm.
Users can try to instantiate it with any algorithm using AF_ALG, for example:

	struct sockaddr_alg addr = {
		.salg_type = "hash",
		.salg_name = "mcryptd(md5)",
	};
	
	int fd = socket(AF_ALG, SOCK_SEQPACKET, 0);

	bind(fd, (struct sockaddr *)&addr, sizeof(addr));

Currently, this instantly crashes the kernel.

Eric
