From: Tony Battersby <tonyb@cybernetics.com>
Subject: Re: [PATCH v2 5/8] lib: introduce sg_nents_len_chained
Date: Fri, 18 Sep 2015 12:19:33 -0400
Message-ID: <55FC3995.8050600@cybernetics.com>
References: <1442581036-23789-1-git-send-email-clabbe.montjoie@gmail.com>
 <1442581036-23789-6-git-send-email-clabbe.montjoie@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	lee.nipper@gmail.com, yuan.j.kang@gmail.com
To: LABBE Corentin <clabbe.montjoie@gmail.com>,
	herbert@gondor.apana.org.au, davem@davemloft.net,
	akpm@linux-foundation.org, arnd@arndb.de, axboe@fb.com,
	david.s.gordon@intel.com, martin.petersen@oracle.com,
	robert.jarzmik@free.fr, thomas.lendacky@amd.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1442581036-23789-6-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 09/18/2015 08:57 AM, LABBE Corentin wrote:
> +	for (nents = 0, total = 0; sg; sg = sg_next(sg)) {
> +		nents++;
> +		total += sg->length;
> +		if (!sg_is_last(sg) && (sg + 1)->length == 0 && chained)
> +			*chained = true;
> +		if (total >= len)
> +			return nents;
> +	}
> +
>

(resending with fixed formatting; Thunderbird seems braindamaged lately)

It seems to me like the check for total >= len should be above the check
for chaining.  The way the code is now, it will return chained = true if
the first "unneeded" sg vector is a chain, which does not make intuitive
sense.

But why do drivers even need this at all?  Here is a typical usage:

int qce_mapsg(struct device *dev, struct scatterlist *sg, int nents,
          enum dma_data_direction dir, bool chained)
{
    int err;

    if (chained) {
        while (sg) {
            err = dma_map_sg(dev, sg, 1, dir);
            if (!err)
                return -EFAULT;
            sg = sg_next(sg);
        }
    } else {
        err = dma_map_sg(dev, sg, nents, dir);
        if (!err)
            return -EFAULT;
    }

    return nents;
}

Here is another:

static int talitos_map_sg(struct device *dev, struct scatterlist *sg,
              unsigned int nents, enum dma_data_direction dir,
              bool chained)
{
    if (unlikely(chained))
        while (sg) {
            dma_map_sg(dev, sg, 1, dir);
            sg = sg_next(sg);
        }
    else
        dma_map_sg(dev, sg, nents, dir);
    return nents;
}

Can anyone clarify why you can't just use dma_map_sg(dev, sg, nents,
dir) always?  It should be able to handle chained scatterlists just fine.

If the check for chaining is a just workaround for some problem in
dma_map_sg(), maybe it would be better to fix dma_map_sg() instead,
which would eliminate the need for sg_nents_len_chained() and all these
buggy workarounds (e.g. if chained is true, qce_mapsg() can leave the
DMA list partially mapped when it returns -EFAULT, and talitos_map_sg()
doesn't even check for errors).

One problem that I see is that sg_last() in scatterlist.c has a
"BUG_ON(!sg_is_last(ret));" if CONFIG_DEBUG_SG is enabled, and using a
smaller-than-original nents (as returned by sg_nents_len_chained()) with
the same scatterlist will trigger that bug.  But that should be true
regardless of whether chaining is used or not.  For example, talitos.c
calls sg_last() in a way that can trigger that bug.

For anyone willing to dig further, these are the first two commits that
introduce code like this:

4de9d0b547b9 "crypto: talitos - Add ablkcipher algorithms" (2009)
643b39b031f5 "crypto: caam - chaining support" (2012)
(CC'ing the original authors)

Tony Battersby
Cybernetics
