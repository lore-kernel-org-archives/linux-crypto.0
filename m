From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] [RESEND] crypto test: use print_hex_dump from
	<linux/kernel.h> instead
Date: Mon, 26 Nov 2007 10:01:44 -0800
Message-ID: <1196100104.31590.11.camel@localhost>
References: <20071126143939.GB28022@gondor.apana.org.au>
	 <1196098095-8995-1-git-send-email-crquan@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	dengxw@163.com, Randy Dunlap <randy.dunlap@oracle.com>
To: Denis Cheng <crquan@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from DSL022.labridge.com ([206.117.136.22]:2020 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751494AbXKZSDF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 26 Nov 2007 13:03:05 -0500
In-Reply-To: <1196098095-8995-1-git-send-email-crquan@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, 2007-11-27 at 01:28 +0800, Denis Cheng wrote:
> -static void hexdump(unsigned char *buf, unsigned int len)
> -{
> -	while (len--)
> -		printk("%02x", *buf++);
> -
> -	printk("\n");
> -}

#define hexdump(buf, len) \
	print_hex_dump(KERN_CONT, "", DUMP_PREFIX_NONE, 16, 1, \
	               (buf), (len), false)

requires no other changes.
