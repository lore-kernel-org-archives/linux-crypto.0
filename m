Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A5BE1A6;
	Fri,  1 Dec 2023 15:39:00 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1r9D5s-005xu4-QL; Sat, 02 Dec 2023 07:38:49 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 02 Dec 2023 07:38:58 +0800
Date: Sat, 2 Dec 2023 07:38:58 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Edward Adam Davis <eadavis@qq.com>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, olivia@selenic.com,
	syzbot+c52ab18308964d248092@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH] hwrng: core - fix task hung in hwrng_fillfn
Message-ID: <ZWpukgSDlA6UFR6e@gondor.apana.org.au>
References: <ZWnGV39HJr9uUB2/@gondor.apana.org.au>
 <tencent_B2D2C5864C49BDAEE0AEC1CC9627E3C6CF06@qq.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_B2D2C5864C49BDAEE0AEC1CC9627E3C6CF06@qq.com>

On Fri, Dec 01, 2023 at 08:34:12PM +0800, Edward Adam Davis wrote:
>
> According to splat, after a page fault occurred, the attempt to retrieve 
> rcu_read_lock() failed, resulting in a timeout of 143s. This is my speculation.

Oh I see what's going on.  The reproducer is mapping /dev/hwrng, so
the write to user-space is then triggering another read which then
dead-locks.

Let me think about this.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
