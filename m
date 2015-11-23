From: Hannes Frederic Sowa <hannes@stressinduktion.org>
Subject: Re: [RFC PATCH 0/2] Crypto kernel TLS socket
Date: Mon, 23 Nov 2015 20:10:56 +0100
Message-ID: <1448305856.1624224.447959609.3998E9E7@webmail.messagingengine.com>
References: <cover.1448299690.git.davejwatson@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, kernel-team@fb.com
To: Dave Watson <davejwatson@fb.com>,
	Tom Herbert <tom@herbertland.com>, netdev@vger.kernel.org,
	davem@davemloft.net,
	Sowmini Varadhan <sowmini.varadhan@oracle.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <cover.1448299690.git.davejwatson@fb.com>
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hello,

On Mon, Nov 23, 2015, at 18:42, Dave Watson wrote:
> An approach for a kernel TLS socket.
> 
> Only the symmetric encryption / decryption is done in-kernel, as well
> as minimal framing handling.  The handshake is kept in userspace, and
> the negotiated cipher / keys / IVs are then set on the algif_tls
> socket, which is then hooked in to a tcp socket using
> sk_write_space/sk_data_ready hooks.
> 
> If a non application-data TLS record is seen, it is left on the TCP
> socket and an error is returned on the ALG socket, and the record is
> left for userspace to manage. Userspace can't ignore the message, but
> could just close the socket.
> 
> TLS could potentially also be done directly on the TCP socket, but
> seemed a bit harder to work with the OOB data for non application_data
> messages, and the sockopts / CMSGS already exist for ALG sockets.  The
> flip side is having to manage two fds in userspace.
> 
> Some reasons we're looking at this:
> 
> 1) Access to sendfile/splice for CDN-type applications.  We were
>    inspired by Netflix exploring this in FreeBSD
> 
>    https://people.freebsd.org/~rrs/asiabsd_2015_tls.pdf
> 
>    For perf, this patch is almost on par with userspace OpenSSL.
>    Currently there are some copies and allocs to support
>    scatter/gather in aesni-intel_glue.c, but with some extra work to
>    remove those (not included here), a sendfile() is faster than the
>    equivalent userspace read/SSL_write using a 128k buffer by 2~7%.

This argument is mood:

We already have mmap+vmsplice working on TCP sockets and ERR_MSGQUEUE
notifications are already send when to advance the window. Please
provide a benchmark using those already existing facilities.

I am pretty sure you at least need one data copy (as stated in the
referred paper). Linux kernel can do this in user space already. FreeBSD
only implements sendfile, thus this was the easier way for them to go.

> 2) Access to the unencrypted bytes in kernelspace.  For example, Tom
>    Herbert's kcm would need this
> 
>    https://lwn.net/Articles/657999/
> 
> 3) NIC offload. To support running aesni routines on the NIC instead
>    of the processor, we would probably need enough of the framing
>    interface put in kernel.

This would require adding TOE offloading. The kernel community was a
strong opponent to TOE offloading.

Bye,
Hannes
