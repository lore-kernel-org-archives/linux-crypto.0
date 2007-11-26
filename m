From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2] crypto test: use print_hex_dump from <linux/kernel.h>
Date: Mon, 26 Nov 2007 22:39:39 +0800
Message-ID: <20071126143939.GB28022@gondor.apana.org.au>
References: <1196061182-6368-1-git-send-email-crquan@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Randy Dunlap <randy.dunlap@oracle.com>
To: Denis Cheng <crquan@gmail.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755304AbXKZOkD@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1196061182-6368-1-git-send-email-crquan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Nov 26, 2007 at 03:13:02PM +0800, Denis Cheng wrote:
> these utilities implemented in lib/hexdump.c are more handy, please use this.
> 
> Cc: Randy Dunlap <randy.dunlap@oracle.com>
> Signed-off-by: Denis Cheng <crquan@gmail.com>

OK this is pretty nice.  But you just missed out because the
GCM patches that just went in added more hexdump uses :)

So could you please refresh your patch against the latest cryptodev
tree? Please also clamp those long lines to 80 characters.

On an unrelated note, lib/hexdump.c should not print 8-bit text
even though they pass the is_print test.  They just turn up as
crap on Unicode terminals.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
