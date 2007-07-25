From: Milan Broz <mbroz@redhat.com>
Subject: Re: [PATCH 1/3] [DM] dm-crypt: Move post-processing into
	its	own queue
Date: Wed, 25 Jul 2007 11:45:22 +0200
Message-ID: <46A71BB2.5070806@redhat.com>
References: <20070711030303.GA6730@gondor.apana.org.au>
	<E1I8SWH-0001lg-00@gondolin.me.apana.org.au>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Cc: Christophe Saout <christophe@saout.de>,
	Alasdair G Kergon <agk@redhat.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <E1I8SWH-0001lg-00@gondolin.me.apana.org.au>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
List-Id: linux-crypto.vger.kernel.org

Hi Herbert,

Herbert Xu wrote:
> [DM] dm-crypt: Move post-processing into its own queue
> 
>  
> +	_kcryptd_io_workqueue = create_workqueue("kcryptd-io");

Adding another qlobal per-cpu queue can lead to wasteful creating
of too many kernel threads in system (system with many cores etc.)

I have similar patches in my tree where the queues are created
per crypt device (so every crypt device create two single-threaded
queues).

(And I am thinking about future support of barriers - it can be
really complicated with global workqueue too.)


> @@ -1097,6 +1129,7 @@ static void __exit dm_crypt_exit(void)
>  	if (r < 0)
>  		DMERR("unregister failed %d", r);
>  
> +	destroy_workqueue(_kcryptd_io_workqueue);

also flush_workqueue(_kcryptd_io_workqueue) in crypt_dtr should be there.


Milan
--
mbroz@redhat.com
