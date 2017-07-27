From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH 2/3] staging: ccree: Convert to devm_ioremap_resource for
 map, unmap
Date: Thu, 27 Jul 2017 22:48:29 +0300
Message-ID: <20170727194829.symnl663plxd23uo@mwanda>
References: <CAOtvUMeypygShtn4+nXCsepUrsDhBmZmqXMp60D116P8+2WT4A@mail.gmail.com>
 <1501165654-30601-1-git-send-email-gilad@benyossef.com>
 <1501165654-30601-2-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 driverdev-devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, Suniel Mahesh <sunil.m@techveda.org>,
 Ofir Drang <ofir.drang@arm.com>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <1501165654-30601-2-git-send-email-gilad@benyossef.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
List-Id: linux-crypto.vger.kernel.org

On Thu, Jul 27, 2017 at 05:27:33PM +0300, Gilad Ben-Yossef wrote:
> +	new_drvdata->cc_base = devm_ioremap_resource(&plat_dev->dev,
> +						     req_mem_cc_regs);
> +	if (IS_ERR(new_drvdata->cc_base)) {
> +		rc = PTR_ERR(new_drvdata->cc_base);
>  		goto init_cc_res_err;
                ^^^^^^^^^^^^^^^^^^^^
(This code was in the original and not introduced by the patch.)

Ideally, the goto name should say what the goto does.  In this case it
does everything.  Unfortunately trying to do everything is very
complicated so obviously the error handling is going to be full of bugs.

The first thing the error handling does is:

	ssi_aead_free(new_drvdata);

But this function assumes that if new_drvdata->aead_handle is non-NULL
then that means we have called:

	INIT_LIST_HEAD(&aead_handle->aead_list);

That assumption is false if the aead_handle->sram_workspace_addr
allocation fails.  It can't actually fail in the current code...  So
that's good, I suppose.  Reviewing this code is really hard, because I
have to jump back and forth through several functions in different
files.

Moving on two the second error handling function:

	ssi_hash_free(new_drvdata);

This one has basically the same assumption that if ->hash_handle is
allocated that means we called:

	INIT_LIST_HEAD(&hash_handle->hash_list);

That assumption is not true if ssi_hash_init_sram_digest_consts(drvdata);
fails.  That function can fail in real life.  Except the the error
handling in ssi_hash_alloc() sets ->hash_handle to NULL.  So the bug is
just a leak and not a crashing bug.

I've reviewed the first two lines of the error handling just to give a
feel for how complicated "do everything" style error handling is to
review.

The better way to do error handling is:
1) Only free things which have been allocated.
2) The unwind code should mirror the wind up code.
3) Every allocation function should have a free function.
4) Label names should tell you what the goto does.
5) Use direct returns and literals where possible.
6) Generally it's better to keep the error path and the success path
   separate.
7) Do error handling as opposed to success handling.

	one = alloc();
	if (!one)
		return -ENOMEM;
	if (foo) {
		two = alloc();
		if (!two) {
			ret = -ENOMEM;
			goto free_one;
		}
	}
	three = alloc();
	if (!three) {
		ret = -ENOMEM;
		goto free_two;
	}
	...

	return 0;

free_two:
	if (foo)
		free(two);
free_one:
	free(one);

	return ret;

This style of error handling is easier to review.  You only need to
remember the most recent thing that you have allocated.  You can tell
from the goto that it frees it so you don't have to scroll to the
bottom of the function or jump to a different file.

regards,
dan carpenter
