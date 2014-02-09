From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Fix ccp_run_passthru_cmd dma variable assignments
Date: Sun, 9 Feb 2014 17:20:37 +0800
Message-ID: <20140209092036.GC19429@gondor.apana.org.au>
References: <20140124183934.GA3423@redhat.com>
 <52E2CA48.4070500@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dave Jones <davej@redhat.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org
To: Tom Lendacky <thomas.lendacky@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:33572 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800AbaBIJUo (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 9 Feb 2014 04:20:44 -0500
Content-Disposition: inline
In-Reply-To: <52E2CA48.4070500@amd.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jan 24, 2014 at 02:17:12PM -0600, Tom Lendacky wrote:
> On 01/24/2014 12:39 PM, Dave Jones wrote:
> > There are some suspicious looking lines of code in the new ccp driver, including
> > one that assigns a variable to itself, and another that overwrites a previous assignment.
> > 
> > This may have been a cut-and-paste error where 'src' was forgotten to be changed to 'dst'.
> > I have no hardware to test this, so this is untested.
> 
> Yes, this was a cut-and-paste error that was not discovered with my tests. I've
> updated my testcases and tested/verified this fix.
> 
> Herbert, this should probably go through the cryptodev-2.6 tree right?
> 
> Acked-by: Tom Lendacky <thomas.lendacky@amd.com>

Applied to cryptodev.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
