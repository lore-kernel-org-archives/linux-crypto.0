From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 0/3] Minor CCP improvements and clean-up
Date: Wed, 15 Feb 2017 13:33:26 +0800
Message-ID: <20170215053326.GC14043@gondor.apana.org.au>
References: <20170209214704.11781.28640.stgit@taos>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, thomas.lendacky@amd.com,
        davem@davemloft.net
To: Gary R Hook <gary.hook@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:35983 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750722AbdBOFdk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 15 Feb 2017 00:33:40 -0500
Content-Disposition: inline
In-Reply-To: <20170209214704.11781.28640.stgit@taos>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Feb 09, 2017 at 03:49:38PM -0600, Gary R Hook wrote:
> The following series implements...
>  - Move verbose init messages to debug mode
>  - Update the queue pointers in the event of an error
>  - Simply buffer management and eliminate an unused option

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
