From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH] doc: crypto: warning cleanup
Date: Mon, 24 Aug 2015 15:30:05 +0200
Message-ID: <2770513.ERe0qLmQGB@tauon.atsec.com>
References: <20150823135101.270c6630@xps.lwn.net> <5137031.WPPXXLuRMs@tauon.atsec.com> <20150824020342.0361f3b5@xps.lwn.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org
To: Jonathan Corbet <corbet@lwn.net>
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20150824020342.0361f3b5@xps.lwn.net>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Montag, 24. August 2015, 02:03:42 schrieb Jonathan Corbet:

Hi Jonathan,

>
>> >+ * @base: Common crypto API algorithm data structure
>> 
>> I am wondering: does this really fix the issue? I tried it and it failed
>> (i.e. still produced errors by the parser) due to the exotic definition in
>> of this variable in the C code.
>
>It fixes part of the issue.  The other required a change to kernel-doc,
>which I've posted separately to linux-doc and plan to put in for 4.3.

Thank you. Does that change also fixes the bug report for 
include/crypto/hash.h?

Warning(include/crypto/hash.h:188): No description found for parameter 
'hash_alg_common))))'

For the updated documentation:

Acked-by: Stephan Mueller <smueller@chronox.de>


Ciao
Stephan
