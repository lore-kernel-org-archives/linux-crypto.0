From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v2 5/8] lib: introduce sg_nents_len_chained
Date: Fri, 18 Sep 2015 09:01:29 -0500
Message-ID: <55FC1939.7080407@amd.com>
References: <1442581036-23789-1-git-send-email-clabbe.montjoie@gmail.com> <1442581036-23789-6-git-send-email-clabbe.montjoie@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>
To: LABBE Corentin <clabbe.montjoie@gmail.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<akpm@linux-foundation.org>, <arnd@arndb.de>, <axboe@fb.com>,
	<david.s.gordon@intel.com>, <martin.petersen@oracle.com>,
	<robert.jarzmik@free.fr>, <tonyb@cybernetics.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1442581036-23789-6-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 09/18/2015 07:57 AM, LABBE Corentin wrote:
> Some driver use a modified version of sg_nents_for_len with an
> additional parameter bool *chained for knowing if the scatterlist is
> chained or not.
>
> So, for removing duplicate code, add sg_nents_len_chained in
> lib/scatterlist.c
>
> Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
> ---
>   include/linux/scatterlist.h |  1 +
>   lib/scatterlist.c           | 40 ++++++++++++++++++++++++++++++++++++++++
>   2 files changed, 41 insertions(+)
>
> diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
> index 556ec1e..594cdb0 100644
> --- a/include/linux/scatterlist.h
> +++ b/include/linux/scatterlist.h
> @@ -243,6 +243,7 @@ static inline void *sg_virt(struct scatterlist *sg)
>
>   int sg_nents(struct scatterlist *sg);
>   int sg_nents_for_len(struct scatterlist *sg, u64 len);
> +int sg_nents_len_chained(struct scatterlist *sg, u64 len, bool *chained);
>   struct scatterlist *sg_next(struct scatterlist *);
>   struct scatterlist *sg_last(struct scatterlist *s, unsigned int);
>   void sg_init_table(struct scatterlist *, unsigned int);
> diff --git a/lib/scatterlist.c b/lib/scatterlist.c
> index bafa993..070e396 100644
> --- a/lib/scatterlist.c
> +++ b/lib/scatterlist.c
> @@ -90,6 +90,46 @@ int sg_nents_for_len(struct scatterlist *sg, u64 len)
>   EXPORT_SYMBOL(sg_nents_for_len);
>
>   /**
> + * sg_nents_len_chained - return total count of entries in scatterlist
> + *                        needed to satisfy the supplied length
> + * @sg:		The scatterlist
> + * @len:	The total required length
> + * @chained	A pointer where to store if SG is chained or not
> + *
> + * Description:
> + * Determines the number of entries in sg that are required to meet
> + * the supplied length, taking into account chaining as well
> + * If the scatterlist is chained, set *chained to true.
> + *
> + * Returns:
> + *   the number of sg entries needed, negative error on failure
> + *
> + **/
> +int sg_nents_len_chained(struct scatterlist *sg, u64 len, bool *chained)
> +{
> +	int nents;
> +	u64 total;
> +
> +	if (chained)
> +		*chained = false;
> +
> +	if (!len)
> +		return 0;
> +
> +	for (nents = 0, total = 0; sg; sg = sg_next(sg)) {
> +		nents++;
> +		total += sg->length;
> +		if (!sg_is_last(sg) && (sg + 1)->length == 0 && chained)

Wouldn't it be better to use the sg_is_chain macro to determine if the
the entry is chained instead of checking the length?

Thanks,
Tom

> +			*chained = true;
> +		if (total >= len)
> +			return nents;
> +	}
> +
> +	return -EINVAL;
> +}
> +EXPORT_SYMBOL(sg_nents_len_chained);
> +
> +/**
>    * sg_last - return the last scatterlist entry in a list
>    * @sgl:	First entry in the scatterlist
>    * @nents:	Number of entries in the scatterlist
>
