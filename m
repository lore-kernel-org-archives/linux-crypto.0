From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] checkpatch: add *_ON_STACK to $declaration_macros
Date: Wed, 20 Dec 2017 01:41:55 -0800
Message-ID: <1513762915.1234.91.camel@perches.com>
References: <1498550116-12475-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Ofir Drang <ofir.drang@arm.com>, linux-crypto@vger.kernel.org
To: Gilad Ben-Yossef <gilad@benyossef.com>,
        Andy Whitcroft <apw@canonical.com>,
        linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtprelay0050.hostedemail.com ([216.40.44.50]:48367 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754235AbdLTJl7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Dec 2017 04:41:59 -0500
In-Reply-To: <1498550116-12475-1-git-send-email-gilad@benyossef.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, 2017-06-27 at 10:55 +0300, Gilad Ben-Yossef wrote:
> Add the crypto API *_ON_STACK to $declaration_macros.
> 
> Resolves the following false warning:
> 
> WARNING: Missing a blank line after declarations
> +			int err;
> +			SHASH_DESC_ON_STACK(desc, ctx_p->shash_tfm);
[]
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
[]
> @@ -733,6 +733,7 @@ our $FuncArg = qr{$Typecast{0,1}($LvalOrFunc|$Constant|$String)};
>  our $declaration_macros = qr{(?x:
>  	(?:$Storage\s+)?(?:[A-Z_][A-Z0-9]*_){0,2}(?:DEFINE|DECLARE)(?:_[A-Z0-9]+){1,6}\s*\(|
>  	(?:$Storage\s+)?LIST_HEAD\s*\(|
> +	(?:$Storage\s+)?[A-Z_]*_ON_STACK\(|

A few things:

The crypto _ON_STACK declarations cannot have a $Storage type.

There should be a \s* between the ON_STACK and the open parenthesis

There are other _ON_STACK types than the crypto uses

$ grep -rP --include=*.[ch] -oh "\b[A-Z_]+_ON_STACK\b" * | \
  sort | uniq -c | sort -rn
     68 SKCIPHER_REQUEST_ON_STACK
     45 SHASH_DESC_ON_STACK
     10 AHASH_REQUEST_ON_STACK
      4 PC_LOC_ON_STACK
      4 DECLARE_DPM_WATCHDOG_ON_STACK
      3 HISI_SAS_DECLARE_RST_WORK_ON_STACK
      3 CONFIG_ARCH_TASK_STRUCT_ON_STACK
      1 PT_SIZE_ON_STACK
      1 ALLOC_PT_GPREGS_ON_STACK

So perhaps:

	(?:SKCIPHER_REQUEST|SHASH_DESC|AHASH_REQUEST)_ON_STACK\s*\(
