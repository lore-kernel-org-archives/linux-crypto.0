From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v6 1/5] random: Blocking API for accessing nonblocking_pool
Date: Tue, 19 May 2015 16:27:54 +0200
Message-ID: <1637466.ZUdUCXWXVs@tauon>
References: <1921857.OvxEu6y28S@tachyon.chronox.de> <20150519135028.GC20421@thunk.org> <20150519141805.GA32663@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Theodore Ts'o <tytso@mit.edu>, pebolle@tiscali.nl,
	andreas.steffen@strongswan.org, sandyinchina@gmail.com,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150519141805.GA32663@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Dienstag, 19. Mai 2015, 22:18:05 schrieb Herbert Xu:

Hi Herbert,

>On Tue, May 19, 2015 at 09:50:28AM -0400, Theodore Ts'o wrote:
>> Finally, this is only going to block *once*, when the system is
>> initially botting up.  Why is it so important that we get the
>> asynchronous nature of this right, and why can't we solve it simply by
>> just simply doing the work in a workqueue, with a completion barrier
>> getting triggered once /dev/random initializes itself, and just simply
>> blocking the module unload until /dev/random is initialized?
>
>I guess I'm still thinking of the old work queue code before
>Tejun's cmwq work.  Yes blocking in a work queue should be fine
>as there is usually just one DRBG instance.

The current modification with patch 1 to random.c is the smallest change to 
date. Is that then appropriate?

Herbert, based on your comment now, would the currently discussed patch with 
waiting in the work queue in patch 3 appropriate? Or what would you like to 
see changed?

Ciao
Stephan
