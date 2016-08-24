From: Corentin LABBE <clabbe.montjoie@gmail.com>
Subject: Re: [PATCH v2 2/2] HWRNG: thunderx: Add Cavium HWRNG driver for
 ThunderX SoC.
Date: Wed, 24 Aug 2016 07:46:19 +0200
Message-ID: <874d0bce-cf9b-8772-5af4-ec3844b3b255@gmail.com>
References: <1471994835-2423-1-git-send-email-okhaliq@caviumnetworks.com>
 <1471994835-2423-3-git-send-email-okhaliq@caviumnetworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Omer Khaliq <okhaliq@caviumnetworks.com>, linux-kernel@vger.kernel.org,
 linux-pci@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, bhelgaas@google.com, mpm@selenic.com,
 herbert@gondor.apana.org.au, Ananth.Jasty@cavium.com, David.Daney@cavium.com
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1471994835-2423-3-git-send-email-okhaliq@caviumnetworks.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

Hello

> +/* Read data from the RNG unit */
> +static int cavium_rng_read(struct hwrng *rng, void *dat, size_t max, bool wait)
> +{
> +	struct cavium_rng *p = container_of(rng, struct cavium_rng, ops);
> +	unsigned int size = max;
> +
> +	while (size >= 8) {
> +		*((u64 *)dat) = readq(p->result);
> +		size -= 8;
> +		dat += 8;
> +	}

I think you could use readsq()
This will increase throughput

Regards

LABBE Corentin
