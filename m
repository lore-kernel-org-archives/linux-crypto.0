From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [patch] crypto: sha256-mb - cleanup a || vs | typo
Date: Thu, 30 Jun 2016 15:33:27 +0300
Message-ID: <20160630123327.GD32301@mwanda>
References: <20160629144242.GE22818@mwanda>
 <8538242a-eab7-127e-e47e-26027fee4f6d@zytor.com>
 <20160630075056.GR32247@mwanda>
 <1467285386.24287.143.camel@perches.com>
 <57750665.7000703@bfs.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Joe Perches <joe@perches.com>, "H. Peter Anvin" <hpa@zytor.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Megha Dey <megha.dey@intel.com>,
	"Wang, Rui Y" <rui.y.wang@intel.com>,
	Denys Vlasenko <dvlasenk@redhat.com>,
	Xiaodong Liu <xiaodong.liu@intel.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
To: walter harms <wharms@bfs.de>
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <57750665.7000703@bfs.de>
Sender: kernel-janitors-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The difference between | and || is that || has ordering constraints.
It's from the C standard, and not the compiler version.

regards,
dan carpenter

