From: LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: Re: [PATCH v2 5/5] hwrng: amd: Rework of the amd768-hwrng driver
Date: Fri, 26 Aug 2016 10:38:02 +0200
Message-ID: <20160826083802.GA32290@Red>
References: <1472127395-32195-1-git-send-email-clabbe.montjoie@gmail.com>
 <1472127395-32195-6-git-send-email-clabbe.montjoie@gmail.com>
 <20160825145638.GD10637@io.lakedaemon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: mpm@selenic.com, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Jason Cooper <jason@lakedaemon.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160825145638.GD10637@io.lakedaemon.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Aug 25, 2016 at 02:56:38PM +0000, Jason Cooper wrote:
> Hi Corentin,
> 
> On Thu, Aug 25, 2016 at 02:16:35PM +0200, LABBE Corentin wrote:
> > This patch convert the hwrng interface used by amd768-rng to its new API
> > by replacing data_read()/data_present() by read().
> > 
> > Furthermore, Instead of having two global variable, it's better to use a
> > private struct. This will permit to remove amd_pdev variable.
> > 
> > Finally, Instead of accessing hw directly via pmbase, it's better to
> > access after ioport_map() via ioread32/iowrite32.
> 
> I was going to recommend a better $subject line, but now I see why it's
> vague. :(  I would recommend breaking this patch up into three:
> 
>   hwrng: amd - Access hardware via ioread32/iowrite32
>   hwrng: amd - Replace global variable with private struct
>   hwrng: amd - Convert to new hwrng read() API
> 

That was my first idea, but believed that it wasnt worth it.

Anyway I will do it.

Regards
LABBE Corentin
