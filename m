From: Paul Bolle <pebolle@tiscali.nl>
Subject: Re: [PATCH 12/12] crypto/sha-mb/sha1_mb.c : Syntax error
Date: Mon, 16 Mar 2015 12:28:23 +0100
Message-ID: <1426505303.26437.40.camel@x220>
References: <1426282701-10516-1-git-send-email-ameenali023@gmail.com>
	 <20150316105048.GD793@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Ameen Ali <ameenali023@gmail.com>, tim.c.chen@linux.intel.com,
	davem@davemloft.net, tglx@linutronix.de, mingo@redhat.com,
	hpa@zytor.com, x86@kernel.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:53218 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752806AbbCPL20 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 16 Mar 2015 07:28:26 -0400
In-Reply-To: <20150316105048.GD793@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, 2015-03-16 at 21:50 +1100, Herbert Xu wrote:
> On Fri, Mar 13, 2015 at 11:38:21PM +0200, Ameen Ali wrote:
> > fixing a syntax-error .
> > 
> > Signed-off-by : Ameen Ali <AmeenAli023@gmail.com>
> 
> Applied.

The commit summary and the commit explanation are a bit misleading. This
is not a syntax error: it actually compiles just fine with GCC 4.8. (I
looked into that wondering whether this was stable material.) It's
telling that the commit explanation doesn't contain a copy of the error
message, which would have been very helpful if this really was a syntax
error.

The old code apparently works because the preprocessor converts
time_before() into time_after(). And the code generated for time_after()
will in its turn be wrapped in parentheses. That is, this generates
valid syntax by, well, accident. So this could as well be labeled a
style fix. A fix for a rather serious style defect, but still.


Paul Bolle
