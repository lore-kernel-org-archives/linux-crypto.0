From: arno@natisbad.org (Arnaud Ebalard)
Subject: Re: [PATCH 0/2] crypto: add new driver for Marvell CESA
Date: Fri, 10 Apr 2015 01:21:25 +0200
Message-ID: <87twwo51my.fsf@natisbad.org>
References: <1428591523-1780-1-git-send-email-boris.brezillon@free-electrons.com>
 <55269C05.2060401@gmail.com> <20150409175735.342d0111@bbrezillon>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Mark Rutland <mark.rutland@arm.com>,
 Boris Brezillon <boris.brezillon@free-electrons.com>,
 Thomas Petazzoni <info@free-electrons.com>,
 Herbert Xu <herbert@gondor.apana.org.au>, Pawel Moll <pawel.moll@arm.com>,
 Ian Campbell <ijc+devicetree@hellion.org.uk>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Eran Ben-Avi <benavi@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
 devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
 Andrew Lunn <andrew@lunn.ch>, linux-crypto@vger.kernel.org,
 Kumar Gala <galak@codeaurora.org>,
 Gregory CLEMENT <gregory.clement@free-electrons.com>,
 Tawfik Bayouk <tawfik@marvell.com>, "David S. Miller" <davem@davemloft.net>,
 Lior Amsalem <alior@marvell.com>, Jason Cooper <jason@lakedaemon.net>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

Hi Sebastien,

Boris Brezillon <boris.brezillon@free-electrons.com> writes:

>> if you include a bunch of performance measurements, I guess it will help
>> you to get an agreement of replacing the driver instead of reworking it.
>
> Yep, I made some measurements using tcrypt a while ago, I'll provide
> them in the next round.

Here are some tests on 2 Marvell SoC (I do not have dove platforms at
hand and did not collect the results for A370):

  - Kirkwood 88F6282 (Feroceon 88FR131 rev 1) at 1.6GHz
  - Armada XP (mv78230, i.e. 2 core @1.2GHz)

The targets are AES ECB and CBC encryption (decryption is similar
performance-wise), done w/ tcrypt (mode=500 passed to tcrypt module).

For each SoC, the various tests done by tcrypt are the following:

AES ECB/CBC encryption:

t  0 (128 bit key, 16 byte blocks)
t  1 (128 bit key, 64 byte blocks)
t  2 (128 bit key, 256 byte blocks)
t  3 (128 bit key, 1024 byte blocks)
t  4 (128 bit key, 8192 byte blocks)
t  5 (192 bit key, 16 byte blocks)
t  6 (192 bit key, 64 byte blocks)
t  7 (192 bit key, 256 byte blocks)
t  8 (192 bit key, 1024 byte blocks)
t  9 (192 bit key, 8192 byte blocks)
t 10 (256 bit key, 16 byte blocks)
t 11 (256 bit key, 64 byte blocks)
t 12 (256 bit key, 256 byte blocks)
t 13 (256 bit key, 1024 byte blocks)
t 14 (256 bit key, 8192 byte blocks)

The three columns provide the value for software implementation
(aes-asm), current driver (if available for that SoC), submitted
v0. The percentage is the improvement against software
implementation.

         soft         current driver          submitted v0     
                      (if available)


KW:

ECB
   t 0:  5.23 MB/s   1.01 MB/s (-80.58%)    1.11 MB/s (-78.75%) 
   t 1: 12.40 MB/s   3.70 MB/s (-70.16%)    4.14 MB/s (-66.59%) 
   t 2: 18.94 MB/s  10.81 MB/s (-42.94%)   13.86 MB/s (-26.78%) 
   t 3: 21.79 MB/s  20.69 MB/s  (-5.05%)   33.80 MB/s  (55.12%)  
   t 4: 22.54 MB/s  25.97 MB/s  (15.23%)   50.27 MB/s (123.05%) 

   t 5:  5.00 MB/s   1.01 MB/s (-79.75%)    1.10 MB/s (-78.02%) 
   t 6: 11.35 MB/s   3.70 MB/s (-67.41%)    3.84 MB/s (-66.17%) 
   t 7: 16.60 MB/s  10.66 MB/s (-35.81%)   13.59 MB/s (-18.14%) 
   t 8: 18.76 MB/s  20.13 MB/s   (7.29%)   32.30 MB/s  (72.15%)  
   t 9: 19.20 MB/s  25.10 MB/s  (30.74%)   47.11 MB/s (145.37%) 

   t10:  4.85 MB/s   1.02 MB/s (-79.02%)    1.10 MB/s (-77.25%) 
   t11: 10.50 MB/s   3.74 MB/s (-64.35%)    4.10 MB/s (-60.89%) 
   t12: 14.80 MB/s   4.65 MB/s (-68.55%)   13.40 MB/s (-9.43%)  
   t13: 16.47 MB/s  19.22 MB/s  (16.69%)   31.14 MB/s  (89.02%)  
   t14: 16.89 MB/s  24.36 MB/s  (44.18%)   44.33 MB/s (162.40%) 

CBC
   t 0:  4.78 MB/s   0.98 MB/s (-79.50%)    1.09 MB/s (-77.12%) 
   t 1: 11.44 MB/s   3.59 MB/s (-68.62%)    4.07 MB/s (-64.41%) 
   t 2: 17.66 MB/s  10.53 MB/s (-40.38%)   13.67 MB/s (-22.58%) 
   t 3: 20.41 MB/s  20.42 MB/s   (0.00%)   33.50 MB/s  (64.10%)  
   t 4: 21.14 MB/s  25.86 MB/s  (22.36%)   50.02 MB/s (136.63%) 

   t 5:  4.58 MB/s   0.98 MB/s (-78.64%)    1.08 MB/s (-76.31%) 
   t 6: 10.54 MB/s   3.58 MB/s (-66.00%)    4.04 MB/s (-61.68%) 
   t 7: 15.61 MB/s  10.39 MB/s (-33.49%)   13.40 MB/s (-14.16%) 
   t 8: 17.73 MB/s  19.88 MB/s  (12.10%)   32.04 MB/s  (80.69%)  
   t 9: 18.18 MB/s  25.02 MB/s  (37.60%)   46.90 MB/s (157.97%) 

   t10:  4.45 MB/s   0.98 MB/s (-77.96%)    1.09 MB/s (-75.62%) 
   t11:  9.80 MB/s   3.60 MB/s (-63.28%)    4.03 MB/s (-58.83%) 
   t12: 14.01 MB/s   4.34 MB/s (-69.01%)   13.24 MB/s  (-5.48%)  
   t13: 15.67 MB/s  19.44 MB/s  (24.01%)   30.90 MB/s  (97.17%)  
   t14: 16.09 MB/s  24.28 MB/s  (50.85%)   44.15 MB/s (174.34%) 

XP:

ECB
   t 0:  8.85 MB/s                          0.77 MB/s (-91.25%) 
   t 1: 21.73 MB/s                          3.09 MB/s (-85.79%) 
   t 2: 34.81 MB/s                         12.35 MB/s (-64.52%) 
   t 3: 40.81 MB/s                         38.68 MB/s  (-5.22%) 
   t 4: 42.69 MB/s                         84.52 MB/s  (98.00%) 

   t 5:  8.55 MB/s                          0.78 MB/s (-90.92%) 
   t 6: 20.63 MB/s                          3.11 MB/s (-84.92%) 
   t 7: 31.47 MB/s                         12.43 MB/s (-60.52%) 
   t 8: 36.07 MB/s                         38.08 MB/s   (5.58%) 
   t 9: 37.09 MB/s                         80.43 MB/s (116.85%) 

   t10:  8.25 MB/s                          0.78 MB/s (-90.56%) 
   t11: 19.19 MB/s                          3.11 MB/s (-83.80%) 
   t12: 28.61 MB/s                         12.42 MB/s (-56.59%) 
   t13: 32.49 MB/s                         37.28 MB/s  (14.74%) 
   t14: 33.56 MB/s                         77.11 MB/s (129.79%) 

CBC   
   t 0:  8.20 MB/s                          0.78 MB/s (-90.53%) 
   t 1: 19.85 MB/s                          3.10 MB/s (-84.36%) 
   t 2: 31.60 MB/s                         12.42 MB/s (-60.69%) 
   t 3: 37.03 MB/s                         38.70 MB/s   (4.51%) 
   t 4: 38.76 MB/s                         84.05 MB/s (116.87%) 

   t 5:  7.69 MB/s                          0.78 MB/s (-89.90%) 
   t 6: 18.62 MB/s                          3.10 MB/s (-83.32%) 
   t 7: 28.47 MB/s                         12.40 MB/s (-56.44%) 
   t 8: 32.73 MB/s                         37.97 MB/s  (16.02%) 
   t 9: 33.73 MB/s                         79.96 MB/s (137.07%) 

   t10:  7.58 MB/s                          0.77 MB/s (-89.88%) 
   t11: 17.59 MB/s                          3.07 MB/s (-82.56%) 
   t12: 26.26 MB/s                         12.28 MB/s (-53.23%) 
   t13: 29.89 MB/s                         37.02 MB/s  (23.87%) 
   t14: 30.87 MB/s                         76.70 MB/s (148.45%)


Cheers,

a+
