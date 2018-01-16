From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v2] net/core: Increase default optmem_max limit
Date: Tue, 16 Jan 2018 19:11:37 +0100
Message-ID: <3580634.dJdEtStb76@tauon.chronox.de>
References: <e7459a93ac46bfe902a1f5b9fd57ed3488feb465.camel@fedoraproject.org> <6842b4da93e5fb588b2e64550a20089e9f60fad6.camel@fedoraproject.org> <02fd8c825b9d77bfc6c7f6318cdddb85fb295ec6.camel@fedoraproject.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: David Miller <davem@davemloft.net>, waltje@uwalt.nl.mugnet.org,
        flla@stud.uni-sb.de, A.Cox@swansea.ac.uk,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        trivial@kernel.org, labbott@redhat.com, zbyszek@in.waw.pl,
        linux-crypto@vger.kernel.org
To: =?ISO-8859-1?Q?Bj=F6rn?= 'besser82' Esser
        <besser82@fedoraproject.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <02fd8c825b9d77bfc6c7f6318cdddb85fb295ec6.camel@fedoraproject.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Dienstag, 16. Januar 2018, 18:16:43 CET schrieb Björn 'besser82' Esser:

Hi Björn,

> With the new Linux Kernel Crypto API User Space Interface
> and its underlying AF_ALG socket, the current default value
> for `net.core.optmem_max` can be exhausted pretty quick when
> using asynchronous IO; on 32 bit systems it is not even enough
> for sending about 10 IOVECs at once to the socket interface.
> 
> To provide consumers of this new user space interface a well
> sufficient and reasonable maximum ancillary buffer size per
> socket by default, the limit is increased to four times of
> the previous setting:
> 
>   * 32 bit systems:  from 10240 bytes to 40960 bytes
>   * 64 bit systems:  from 20480 bytes to 81920 bytes
> 
> This allows for sending 32/64 (32/64 bit) parallel IOVECs at
> once to the socket interface, which should be enough for use
> in real world applications.
> 
> Signed-off-by: Björn Esser <besser82@fedoraproject.org>

Considering NR_FILE defining the default maximum number of file descriptors, 
at max 335 MB of RAM (32 bit) or 670 MB (64 bit) could be allocated which I 
would assume to be ok in current systems.

Reviewed-by: Stephan Mueller <smueller@chronox.de>

Ciao
Stephan
