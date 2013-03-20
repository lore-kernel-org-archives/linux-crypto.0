From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 09/10] workqueue: implement NUMA affinity for unbound workqueues
Date: Wed, 20 Mar 2013 08:32:19 -0700
Message-ID: <CAOS58YPSRyabrk9Oh=uqWMzZ06ZayGrMgjcbf584T9dsYwaeDA@mail.gmail.com>
References: <1363737629-16745-1-git-send-email-tj@kernel.org>
	<1363737629-16745-10-git-send-email-tj@kernel.org>
	<CACvQF51hz_H72zVTt4R=P84RDxat+WTe-Ehw8Zbj0cjifNt4ag@mail.gmail.com>
	<20130320150554.GX3042@htj.dyndns.org>
	<CACvQF531UAJVBr1XtT2aZYOt6XATOC383jM=rfiOR-SB3Hj62w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: laijs@cn.fujitsu.com, axboe@kernel.dk, jack@suse.cz,
	fengguang.wu@intel.com, jmoyer@redhat.com, zab@redhat.com,
	linux-kernel@vger.kernel.org, herbert@gondor.apana.org.au,
	davem@davemloft.net, linux-crypto@vger.kernel.org
To: Lai Jiangshan <eag0628@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qc0-f175.google.com ([209.85.216.175]:58181 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902Ab3CTPcU (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 20 Mar 2013 11:32:20 -0400
In-Reply-To: <CACvQF531UAJVBr1XtT2aZYOt6XATOC383jM=rfiOR-SB3Hj62w@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Mar 20, 2013 at 8:26 AM, Lai Jiangshan <eag0628@gmail.com> wrote:
>>         for_eahc_node(node)
>>                 if (pwq_tbl[node] != dfl_pwq)
>>                         kfree(pwq_tbl[node]);
>>         kfree(dfl_pwq);
>
> I also missed.
> we still need to put_unbound_pool() before free(pwq)

Yeap, we do.  Wonder whether we can just use put_pwq() there. I'll see if I can.

-- 
tejun
