From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHSET wq/for-3.10] workqueue: NUMA affinity for unbound
 workqueues
Date: Wed, 20 Mar 2013 11:57:08 -0700
Message-ID: <20130320185708.GB31256@htj.dyndns.org>
References: <1363737629-16745-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: axboe@kernel.dk, jack@suse.cz, fengguang.wu@intel.com,
	jmoyer@redhat.com, zab@redhat.com, linux-kernel@vger.kernel.org,
	herbert@gondor.apana.org.au, davem@davemloft.net,
	linux-crypto@vger.kernel.org
To: laijs@cn.fujitsu.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-vc0-f173.google.com ([209.85.220.173]:37990 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756203Ab3CTS5R (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 20 Mar 2013 14:57:17 -0400
Content-Disposition: inline
In-Reply-To: <1363737629-16745-1-git-send-email-tj@kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Mar 19, 2013 at 05:00:19PM -0700, Tejun Heo wrote:
> and also available in the following git branch.
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git review-numa

Branch rebased on top of the current wq/for-3.10 with updated patches.
The new comit ID is 9555fbc12d786a9eae7cf7701a6718a0c029173e.

Thanks.

-- 
tejun
