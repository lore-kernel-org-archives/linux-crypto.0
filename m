From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH] random: add random_initialized command line param
Date: Mon, 18 May 2015 21:16:38 +0200
Message-ID: <477328243.LmeEDk1ili@tauon>
References: <4206400.x843ypJTc1@tachyon.chronox.de> <20150518184209.GA2871@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34833 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754224AbbERTQm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 18 May 2015 15:16:42 -0400
In-Reply-To: <20150518184209.GA2871@thunk.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 18. Mai 2015, 14:42:09 schrieb Theodore Ts'o:

Hi Theodore,

>On Mon, May 18, 2015 at 06:25:25PM +0200, Stephan Mueller wrote:
>> Make the threshold at which the output entropy pools are considered to
>> be initialized configurable via a kernel command line option. The
>> current integer value of 128 bits is a good default value. However, some
>> user groups may want to use different values. For example, the SOGIS
>> group now requires 125 bits at least (BSI, the participant at that group
>> used to require 100 bits). NIST moved from 80 bits to 112 bits starting
>> with 2014.
>> 
>> It is therefore to be expected that in the future, this threshold may
>> increase for different user groups.
>> 
>> CC: Ted Tso <tytso@mit.edu>
>> Signed-off-by: Stephan Mueller <smueller@chronox.de>
>
>How much does 125 vs 112 vs 128 bits really matter?  Is the cost of
>waiting the extra 16 bits (the difference between 112 and 128 bits)
>really that high?  I'm not entirely convincd that adding Yet Another
>Tuning parameter is really worth it.  If we stick with 128 bits, we
>will satisfy SOGIS, BSI, NIST, etc., and I would find it difficult to
>believe that someone would want 132, 147, etc., bits.

I hear more and more discussions about recommendations to use AES 256 and not 
AES 128.

These kind of recommendations will eventually also affect the entropy 
requirements for noise sources. This is my motivation for the patch: allowing 
different user groups to set the minimum bar for the nonblocking pool to 
*higher* levels (the examples for 80 to 112 bits or 100 to 125 bits shall just 
show that there are active revisions of entropy requirements).

Ciao
Stephan
