From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v5 2/7] crypto: SHA1 multibuffer crypto hash
 infrastructure
Date: Fri, 25 Jul 2014 09:26:05 +0200
Message-ID: <20140725072605.GU3935@laptop>
References: <cover.1406033477.git.tim.c.chen@linux.intel.com>
 <1406066972.2970.804.camel@schen9-DESK>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"David S.Miller" <davem@davemloft.net>,
	Ingo Molnar <mingo@kernel.org>,
	Chandramouli Narayanan <mouli@linux.intel.com>,
	Vinodh Gopal <vinodh.gopal@intel.com>,
	James Guilford <james.guilford@intel.com>,
	Wajdi Feghali <wajdi.k.feghali@intel.com>,
	Jussi Kivilinna <jussi.kivilinna@iki.fi>,
	Thomas Gleixner <tglx@linutronix.de>,
	Tadeusz Struk <tadeusz.struk@intel.com>, tkhai@yandex.ru,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Tim Chen <tim.c.chen@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1406066972.2970.804.camel@schen9-DESK>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Jul 22, 2014 at 03:09:32PM -0700, Tim Chen wrote:
> This patch introduces the multi-buffer crypto daemon which is responsible
> for submitting crypto jobs in a work queue to the responsible multi-buffer
> crypto algorithm.  The idea of the multi-buffer algorihtm is to put
> data streams from multiple jobs in a wide (AVX2) register and then
> take advantage of SIMD instructions to do crypto computation on several
> buffers simultaneously.
> 
> The multi-buffer crypto daemon is also responsbile for flushing the
> remaining buffers to complete the computation if no new buffers arrive
> for a while.

How is any of this SHA1 specific as the Subject says it is?
