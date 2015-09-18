From: Tony Battersby <tonyb@cybernetics.com>
Subject: Re: [PATCH v2 5/8] lib: introduce sg_nents_len_chained
Date: Fri, 18 Sep 2015 17:25:47 -0400
Message-ID: <55FC815B.8020206@cybernetics.com>
References: <1442581036-23789-1-git-send-email-clabbe.montjoie@gmail.com>
 <1442581036-23789-6-git-send-email-clabbe.montjoie@gmail.com>
 <55FC3995.8050600@cybernetics.com>
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
In-Reply-To: <55FC3995.8050600@cybernetics.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 09/18/2015 12:19 PM, Tony Battersby wrote:
> But why do drivers even need this at all?  Here is a typical usage:
>
> int qce_mapsg(struct device *dev, struct scatterlist *sg, int nents,
>           enum dma_data_direction dir, bool chained)
> {
>     int err;
>
>     if (chained) {
>         while (sg) {
>             err = dma_map_sg(dev, sg, 1, dir);
>             if (!err)
>                 return -EFAULT;
>             sg = sg_next(sg);
>         }
>     } else {
>         err = dma_map_sg(dev, sg, nents, dir);
>         if (!err)
>             return -EFAULT;
>     }
>
>     return nents;
> }
>
> Here is another:
>
> static int talitos_map_sg(struct device *dev, struct scatterlist *sg,
>               unsigned int nents, enum dma_data_direction dir,
>               bool chained)
> {
>     if (unlikely(chained))
>         while (sg) {
>             dma_map_sg(dev, sg, 1, dir);
>             sg = sg_next(sg);
>         }
>     else
>         dma_map_sg(dev, sg, nents, dir);
>     return nents;
> }
>
> Can anyone clarify why you can't just use dma_map_sg(dev, sg, nents,
> dir) always?  It should be able to handle chained scatterlists just fine.

After further investigation, it looks like this was a remnant of
scatterwalk_sg_next() which was removed by commit 5be4d4c94b1f ("crypto:
replace scatterwalk_sg_next with sg_next").  Apparently crypto
scatterlists used to be chained differently than normal scatterlists, so
functions like dma_map_sg() would not work on a chained crypto
scatterlist, but that is no longer the case.

So instead of adding a new function sg_nents_len_chained(), a better
cleanup would be:
1) replace the driver-specific functions with calls to sg_nents_for_len()
2) get rid of the "chained" variables
3) always call dma_map_sg()/dma_unmap_sg() for the entire scatterlist
regardless of whether or not the scatterlist is chained

Would someone more familiar with the crypto API please confirm that my
suggestions are correct?

Tony Battersby
Cybernetics
