From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH RESEND] checkpatch: add *_ON_STACK to declaration_macros
Date: Wed, 20 Dec 2017 10:33:19 +0100
Message-ID: <20171220093319.GB16177@kroah.com>
References: <1513758679-14532-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andy Whitcroft <apw@canonical.com>, Joe Perches <joe@perches.com>,
        Ofir Drang <ofir.drang@arm.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1513758679-14532-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Dec 20, 2017 at 08:31:19AM +0000, Gilad Ben-Yossef wrote:
> Add the crypto API *_ON_STACK to $declaration_macros.
> 
> Resolves the following false warning:
> 
> WARNING: Missing a blank line after declarations
> +			int err;
> +			SHASH_DESC_ON_STACK(desc, ctx_p->shash_tfm);
> 
> Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
