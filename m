From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: sha512: make it work, undo percpu message schedule
Date: Wed, 11 Jan 2012 03:12:30 +0300
Message-ID: <20120111001230.GB3801@p183.telecom.by>
References: <20120111000040.GA3801@p183.telecom.by>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
	ken@codelabs.ch
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:32840 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780Ab2AKAMg (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 10 Jan 2012 19:12:36 -0500
Content-Disposition: inline
In-Reply-To: <20120111000040.GA3801@p183.telecom.by>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jan 11, 2012 at 03:00:40AM +0300, Alexey Dobriyan wrote:
> -	memset(W, 0, sizeof(__get_cpu_var(msg_schedule)));

And, yes, this is intentional -- modern gcc pisses on stone age data clearing.
