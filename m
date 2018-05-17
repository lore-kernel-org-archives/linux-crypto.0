From: Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: Re: [PATCH] crypto: reorder paes test lexicographically
Date: Thu, 17 May 2018 10:14:12 +0200
Message-ID: <20180517081412.GA1801@Red>
References: <1526025847-13134-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Abdul Haleem <abdhalee@linux.vnet.ibm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Ofir Drang <ofir.drang@arm.com>,
        linux-next <linux-next@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        sachinp <sachinp@linux.vnet.ibm.com>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1526025847-13134-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, May 11, 2018 at 09:04:06AM +0100, Gilad Ben-Yossef wrote:
> Due to a snafu "paes" testmgr tests were not ordered
> lexicographically, which led to boot time warnings.
> Reorder the tests as needed.
> 
> Fixes: a794d8d ("crypto: ccree - enable support for hardware keys")
> Reported-by: Abdul Haleem <abdhalee@linux.vnet.ibm.com>
> Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>

Tested-by: Corentin Labbe <clabbe.montjoie@gmail.com>

Thanks
