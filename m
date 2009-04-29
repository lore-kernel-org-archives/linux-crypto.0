From: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH 1/2] add infrastructure for ansi_cprng self-tests
Date: Wed, 29 Apr 2009 06:55:01 -0400
Message-ID: <20090429105501.GE7227@hmsreliant.think-freely.org>
References: <200904282127.33190.jarod@redhat.com> <200904282128.14153.jarod@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
To: Jarod Wilson <jarod@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:45148 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758220AbZD2KzJ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 29 Apr 2009 06:55:09 -0400
Content-Disposition: inline
In-Reply-To: <200904282128.14153.jarod@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Apr 28, 2009 at 09:28:13PM -0400, Jarod Wilson wrote:
> Add some necessary infrastructure to make it possible to run
> self-tests for ansi_cprng. The bits are likely very specific
> to the ANSI X9.31 CPRNG in AES mode, and thus perhaps should
> be named more specifically if/when we grow additional CPRNG
> support...
> 
> Successfully tested against the cryptodev-2.6 tree and a
> Red Hat Enterprise Linux 5.x kernel with the follow-on
> patch that adds the actual test vectors.
> 
> Signed-off-by: Jarod Wilson <jarod@redhat.com>
> 
Thanks Jarod!
Acked-by: Neil Horman <nhorman@tuxdriver.com>

