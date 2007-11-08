From: Paul Wouters <paul@xelerance.com>
Subject: Re: [Openswan dev] improper initialization of ipsec_table in
 openswan 2.4.9
Date: Wed, 7 Nov 2007 22:18:34 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0711072217340.26825@newtla.xelerance.com>
References: <537818.31005.qm@web62507.mail.re1.yahoo.com>
	<20071108002913.GA27507@securecomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: dev@lists.openswan.org, linux-crypto@vger.kernel.org,
	Eran Ben-Avi <eranpublic@yahoo.com>
To: David McCullough <David_Mccullough@securecomputing.com>
Return-path: <dev-bounces@openswan.org>
In-Reply-To: <20071108002913.GA27507@securecomputing.com>
List-Unsubscribe: <http://lists.openswan.org/mailman/listinfo/dev>,
	<mailto:dev-request@openswan.org?subject=unsubscribe>
List-Archive: <http://lists.openswan.org/pipermail/dev>
List-Post: <mailto:dev@openswan.org>
List-Help: <mailto:dev-request@openswan.org?subject=help>
List-Subscribe: <http://lists.openswan.org/mailman/listinfo/dev>,
	<mailto:dev-request@openswan.org?subject=subscribe>
Sender: dev-bounces@openswan.org
Errors-To: dev-bounces@openswan.org
List-Id: linux-crypto.vger.kernel.org

On Thu, 8 Nov 2007, David McCullough wrote:

> Date: Thu, 8 Nov 2007 10:29:13 +1000
> From: David McCullough <David_Mccullough@securecomputing.com>
> Cc:  <dev@lists.openswan.org>,  <linux-crypto@vger.kernel.org>
> To: Eran Ben-Avi <eranpublic@yahoo.com>
> Subject: Re: [Openswan dev] improper initialization of ipsec_table in openswan
>      2.4.9

> The newly released 2.4.10 version has a fix for this included,  but it
> only names the one field to avoid the structure alignment changes.
> Probably more a topic for the openswan dev list.
>
> I figure it needs to be more like the attached changes to 2.4.9 going forward.
> Will repost one I update to 2.4.10 (and then probably 2.5...) ;-)

The fix as attached, naming the structure items, is already in #testing (2.5.x)

Paul
