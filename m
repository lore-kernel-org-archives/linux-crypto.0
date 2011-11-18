From: Stephen Warren <swarren-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH v7 2/2] crypto: driver for Tegra AES hardware
Date: Fri, 18 Nov 2011 08:42:57 -0800
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF1740D74E74@HQMAIL01.nvidia.com>
References: <1321594953-13390-1-git-send-email-vwadekar@nvidia.com>
 <1321594953-13390-3-git-send-email-vwadekar@nvidia.com>
 <20111118100239.GA8023@totoro>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"linux-tegra-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-tegra-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"olof-nZhT3qVonbNeoWH0uzbU5w@public.gmane.org" <olof-nZhT3qVonbNeoWH0uzbU5w@public.gmane.org>,
	"ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org" <ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>
To: Jamie Iles <jamie-wmLquQDDieKakBO8gow8eQ@public.gmane.org>,
	Varun Wadekar <vwadekar-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-tegra-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111118100239.GA8023@totoro>
Content-Language: en-US
Sender: linux-tegra-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Jamie Iles wrote at Friday, November 18, 2011 3:03 AM:
> On Fri, Nov 18, 2011 at 11:12:33AM +0530, Varun Wadekar wrote:
> > driver supports ecb/cbc/ofb/ansi_x9.31rng modes,
> > 128, 192 and 256-bit key sizes

> > +static int tegra_aes_probe(struct platform_device *pdev)
...
> > +	dev_info(dev, "registered");
> > +	return 0;
> > +
> > +out:
> > +	for (j = 0; j < i; j++)
> > +		crypto_unregister_alg(&algs[j]);
> > +	if (dd->ivkey_base)
> > +		dma_free_coherent(dev, AES_HW_KEY_TABLE_LENGTH_BYTES,
> > +			dd->ivkey_base, dd->ivkey_phys_base);
> > +	if (dd->buf_in)
> > +		dma_free_coherent(dev, AES_HW_DMA_BUFFER_SIZE_BYTES,
> > +			dd->buf_in, dd->dma_buf_in);
> > +	if (dd->buf_out)
> > +		dma_free_coherent(dev, AES_HW_DMA_BUFFER_SIZE_BYTES,
> > +			dd->buf_out, dd->dma_buf_out);
> > +	if (dd->aes_clk)
> > +		clk_put(dd->aes_clk);
> 
> Note that clk_get() _can_ return NULL as a valid clk even if it doesn't
> on tegra which makes this check a little difficult.

You can use IS_ERR to check for whether the clock was "got" or not, but
of course, you'll have to initialize that field to some error value before
any point where the code can "goto out";

-- 
nvpublic
