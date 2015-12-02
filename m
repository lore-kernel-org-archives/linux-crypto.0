From: David Laight <David.Laight@ACULAB.COM>
Subject: RE: ipsec impact on performance
Date: Wed, 2 Dec 2015 11:56:45 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D1CBE0ED7@AcuExch.aculab.com>
References: <20151201175953.GC21252@oracle.com>
 <CALx6S35uLqbuJTAFLMeT-BcyZw_fksz+7BkS=Nt7_3-nYMHF2A@mail.gmail.com>
 <20151201183720.GE21252@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Cc: Linux Kernel Network Developers <netdev@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: 'Sowmini Varadhan' <sowmini.varadhan@oracle.com>,
	Tom Herbert <tom@herbertland.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20151201183720.GE21252@oracle.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Sowmini Varadhan
> Sent: 01 December 2015 18:37
...
> I was using esp-null merely to not have the crypto itself perturb
> the numbers (i.e., just focus on the s/w overhead for now), but here
> are the numbers for the stock linux kernel stack
>                 Gbps  peak cpu util
> esp-null         1.8   71%
> aes-gcm-c-256    1.6   79%
> aes-ccm-a-128    0.7   96%
> 
> That trend made me think that if we can get esp-null to be as close
> as possible to GSO/GRO, the rest will follow closely behind.

That's not how I read those figures.
They imply to me that there is a massive cost for the actual encryption
(particularly for aes-ccm-a-128) - so whatever you do to the esp-null
case won't help.

One way to get a view of the cost of the encryption (and copies)
is to do the operation twice.

	David
