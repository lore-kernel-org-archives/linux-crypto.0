From: =?ISO-8859-1?Q?Bj=F6rn?= 'besser82' Esser
        <besser82@fedoraproject.org>
Subject: Re: [PATCH v2] net/core: Increase default optmem_max limit
Date: Tue, 16 Jan 2018 18:16:43 +0100
Message-ID: <02fd8c825b9d77bfc6c7f6318cdddb85fb295ec6.camel@fedoraproject.org>
References: <e7459a93ac46bfe902a1f5b9fd57ed3488feb465.camel@fedoraproject.org>
         <20180116.093056.695073638764843370.davem@davemloft.net>
         <6842b4da93e5fb588b2e64550a20089e9f60fad6.camel@fedoraproject.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: waltje@uWalt.NL.Mugnet.ORG, flla@stud.uni-sb.de,
        A.Cox@swansea.ac.uk, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, trivial@kernel.org, labbott@redhat.com,
        zbyszek@in.waw.pl, Stephan Mueller <smueller@chronox.de>,
        linux-crypto@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <6842b4da93e5fb588b2e64550a20089e9f60fad6.camel@fedoraproject.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

With the new Linux Kernel Crypto API User Space Interface
and its underlying AF_ALG socket, the current default value
for `net.core.optmem_max` can be exhausted pretty quick when
using asynchronous IO; on 32 bit systems it is not even enough
for sending about 10 IOVECs at once to the socket interface.

To provide consumers of this new user space interface a well
sufficient and reasonable maximum ancillary buffer size per
socket by default, the limit is increased to four times of
the previous setting:

  * 32 bit systems:  from 10240 bytes to 40960 bytes
  * 64 bit systems:  from 20480 bytes to 81920 bytes

This allows for sending 32/64 (32/64 bit) parallel IOVECs at
once to the socket interface, which should be enough for use
in real world applications.

Signed-off-by: Björn Esser <besser82@fedoraproject.org>
---
 net/core/sock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index c0b5b2f17412..de00c571c933 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -316,7 +316,7 @@ __u32 sysctl_wmem_default __read_mostly = SK_WMEM_MAX;
 __u32 sysctl_rmem_default __read_mostly = SK_RMEM_MAX;
 
 /* Maximal space eaten by iovec or ancillary data plus some space */
-int sysctl_optmem_max __read_mostly = sizeof(unsigned long)*(2*UIO_MAXIOV+512);
+int sysctl_optmem_max __read_mostly = sizeof(unsigned long)*4*(2*UIO_MAXIOV+512);
 EXPORT_SYMBOL(sysctl_optmem_max);
 
 int sysctl_tstamp_allow_data __read_mostly = 1;
