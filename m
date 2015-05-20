From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v8 1/5] random: Blocking API for accessing nonblocking_pool
Date: Wed, 20 May 2015 21:53 +0200
Message-ID: <31135926.Ll2JcYSgh4@tachyon.chronox.de>
References: <2051052.uPQa5vlLex@tachyon.chronox.de> <3495247.rGOUdGlGnQ@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: pebolle@tiscali.nl, andreas.steffen@strongswan.org, tytso@mit.edu,
	sandyinchina@gmail.com, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3495247.rGOUdGlGnQ@tachyon.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Mittwoch, 20. Mai 2015, 21:44:46 schrieb Stephan Mueller:

Hi,

> +int get_blocking_random_bytes(void *buf, int nbytes)
> +{
> +	int rc;

Sorry, I should be more carefully here: the rc should be initialized to 0 :-(
-- 
Ciao
Stephan
