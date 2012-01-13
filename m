From: "David Laight" <David.Laight@ACULAB.COM>
Subject: RE: sha512: make it work, undo percpu message schedule
Date: Fri, 13 Jan 2012 11:45:53 -0000
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6D8AF42@saturn3.aculab.com>
References: <1326450942.2272.20.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "Alexey Dobriyan" <adobriyan@gmail.com>,
	<linux-crypto@vger.kernel.org>, <netdev@vger.kernel.org>,
	<ken@codelabs.ch>,
	"Steffen Klassert" <steffen.klassert@secunet.com>
To: "Eric Dumazet" <eric.dumazet@gmail.com>,
	"Herbert Xu" <herbert@gondor.apana.org.au>
Return-path: <netdev-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <1326450942.2272.20.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

 
> Trying a dynamic memory allocation, and fallback on a single
> pre-allocated bloc of memory, shared by all cpus, protected by a
> spinlock
...
> -
> +	static u64 msg_schedule[80];
> +	static DEFINE_SPINLOCK(msg_schedule_lock);
>  	int i;
> -	u64 *W = get_cpu_var(msg_schedule);
> +	u64 *W = kzalloc(sizeof(msg_schedule), GFP_ATOMIC |
__GFP_NOWARN);
>  
> +	
> +	if (!W) {
> +		spin_lock_bh(&msg_schedule_lock);
> +		W = msg_schedule;
> +	}

If this code can be called from an ISR is the kmalloc()
call safe?

If the above is safe, wouldn't it be better to:
1) try to use the static buffer
2) try to kalloc() a buffer
3) spinwait for the static buffer to be free

	David
