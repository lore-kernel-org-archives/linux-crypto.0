From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH v4 5/9] kernel: padata : use __this_cpu_read per-cpu
 helper
Date: Tue, 13 Nov 2012 08:27:03 +0100
Message-ID: <20121113072703.GH22290@secunet.com>
References: <50A1A7E1.3030401@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Kernel-Maillist <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org, cl@linux-foundation.org
To: Shan Wei <shanwei88@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <50A1A7E1.3030401@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Nov 13, 2012 at 09:52:33AM +0800, Shan Wei wrote:
> From: Shan Wei <davidshan@tencent.com>
> 
> For bottom halves off, __this_cpu_read is better.
> 
> Signed-off-by: Shan Wei <davidshan@tencent.com>
> Reviewed-by: Christoph Lameter <cl@linux.com>

Acked-by: Steffen Klassert <steffen.klassert@secunet.com>

Herbert, are you going to take this one?
