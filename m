Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D66623B2A0;
	Mon, 19 May 2025 01:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747618749; cv=none; b=Nw0IHBEhqyMgSfH8mxezrlskiJcHUnn8TgBZ5U61CMPlXxe7/EJV8YLVT3sG/66ySDjPSSsQPQKq5kE1x0V20Kb2+3/TQJRgylI/sMGtv9RdOx+janPaqLqLZSN5wzKZY5xqHtUDm1wwf48lsul0UPlw/HUPMRqcwpJ+iavDkkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747618749; c=relaxed/simple;
	bh=7olO0lQHdVd5lEJRelinV+eG4Jn3HdEuAmugc5pWJfU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OygGbBtNw1b3vXRtpIfl2g3DpdHRzikGSHZrtM746PpAJ0UgIMCzkRr4MGLhRjPc+6DLPrPIz9rb+DP1GRf+yHBoabBcjqXIWkexlt19l4rZoBb37GADeAWak+slninBu7gmUUA5qTX+o/TuJSigqZvZkkB1Qy+B3vXytPlnabM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4b10hC4d9Bz4f3jMN;
	Mon, 19 May 2025 09:38:35 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 12DE81A0A2D;
	Mon, 19 May 2025 09:39:02 +0800 (CST)
Received: from [10.67.109.79] (unknown [10.67.109.79])
	by APP4 (Coremail) with SMTP id gCh0CgD3WF20iypoIMFVMw--.24259S2;
	Mon, 19 May 2025 09:39:01 +0800 (CST)
Message-ID: <b3630b74-2e13-4bf8-b6b5-d78b60057f14@huaweicloud.com>
Date: Mon, 19 May 2025 09:39:00 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] padata: do not leak refcount in reorder_work
To: Dominik Grzegorzek <dominik.grzegorzek@oracle.com>,
 Steffen Klassert <steffen.klassert@secunet.com>,
 Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
 Chen Ridong <chenridong@huawei.com>,
 "open list:PADATA PARALLEL EXECUTION MECHANISM"
 <linux-crypto@vger.kernel.org>,
 "open list:PADATA PARALLEL EXECUTION MECHANISM"
 <linux-kernel@vger.kernel.org>
References: <20250518174531.1287128-1-dominik.grzegorzek@oracle.com>
Content-Language: en-US
From: Chen Ridong <chenridong@huaweicloud.com>
In-Reply-To: <20250518174531.1287128-1-dominik.grzegorzek@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:gCh0CgD3WF20iypoIMFVMw--.24259S2
X-Coremail-Antispam: 1UD129KBjvJXoW7Kw15Gr1UXrWDurWfWr1xZrb_yoW8AF18pr
	W5Cr9rXFW8try5Aa4Uta1rZr1093Wjgw1fKan5Jr1xAry3GFy09w1Uta4SgFWvvrWktwnr
	Za1qqFZ09a9rAF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUylb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxkF7I0En4kS14v26r126r1DMxAIw28IcxkI7VAK
	I48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7
	xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xII
	jxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw2
	0EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x02
	67AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxUwxhLUUUUU
X-CM-SenderInfo: hfkh02xlgr0w46kxt4xhlfz01xgou0bp/



On 2025/5/19 1:45, Dominik Grzegorzek wrote:
> A recent patch that addressed a UAF introduced a reference count leak:
> the parallel_data refcount is incremented unconditionally, regardless
> of the return value of queue_work(). If the work item is already queued,
> the incremented refcount is never decremented.
> 
> Fix this by checking the return value of queue_work() and decrementing
> the refcount when necessary.
> 
> Resolves:
> 
> Unreferenced object 0xffff9d9f421e3d80 (size 192):
>   comm "cryptomgr_probe", pid 157, jiffies 4294694003
>   hex dump (first 32 bytes):
>     80 8b cf 41 9f 9d ff ff b8 97 e0 89 ff ff ff ff  ...A............
>     d0 97 e0 89 ff ff ff ff 19 00 00 00 1f 88 23 00  ..............#.
>   backtrace (crc 838fb36):
>     __kmalloc_cache_noprof+0x284/0x320
>     padata_alloc_pd+0x20/0x1e0
>     padata_alloc_shell+0x3b/0xa0
>     0xffffffffc040a54d
>     cryptomgr_probe+0x43/0xc0
>     kthread+0xf6/0x1f0
>     ret_from_fork+0x2f/0x50
>     ret_from_fork_asm+0x1a/0x30
> 
> Fixes: dd7d37ccf6b1 ("padata: avoid UAF for reorder_work")
> Signed-off-by: Dominik Grzegorzek <dominik.grzegorzek@oracle.com>
> ---
>  kernel/padata.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/padata.c b/kernel/padata.c
> index b3d4eacc4f5d..7eee94166357 100644
> --- a/kernel/padata.c
> +++ b/kernel/padata.c
> @@ -358,7 +358,8 @@ static void padata_reorder(struct parallel_data *pd)
>  		 * To avoid UAF issue, add pd ref here, and put pd ref after reorder_work finish.
>  		 */
>  		padata_get_pd(pd);
> -		queue_work(pinst->serial_wq, &pd->reorder_work);
> +		if (!queue_work(pinst->serial_wq, &pd->reorder_work))
> +			padata_put_pd(pd);
>  	}
>  }
>  

Thank you. I missed this case.
LGTM

Thanks,
Ridong

